pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Io

Singleton {
    id: root

    property list<var> providers

    Process {
        id: queryProc

        signal results(r: list<var>)

        stdout: StdioCollector {
            onStreamFinished: {
                let r = this.text.split("\n").slice(0, -1); // last item is empty because elephant double returns at the end
                try {
                    queryProc.results(r.map(e => JSON.parse(e)["item"]));
                } catch (e) {
                    console.error("Failed to parse JSON output:", e);
                }
            }
        }
    }

    function query(providers: list<string>, query: string, limit: int, callback: var) {
        let q = [providers.join(","), query, limit].join(";");

        var handler = function (results) {
            queryProc.results.disconnect(handler);
            callback(results);
        };
        queryProc.results.connect(handler);

        queryProc.exec(["elephant", "query", "--json", q]);
    }

    function activate(provider: string, identifier: string, action: string, query: string, arguments: list<string>) {
        let a = [provider, identifier, action, query, arguments.join(",")].join(";");

        // activations can't be cancelled nor must be waited
        Quickshell.execDetached(["elephant", "activate", a]);
    }

    function queryProviders() {
        query(["providerlist"], "", 30, r => root.providers = r);
    }
}
