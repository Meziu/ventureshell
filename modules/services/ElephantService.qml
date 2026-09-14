pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Io

Singleton {
    id: root

    property list<var> providers

    onProvidersChanged: {
        providers.map((p) => console.log(p))
    }

    Socket {
        id: elephantSocket

        connected: true
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/elephant/elephant.sock"

        signal results(r: list<var>)

        parser: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                console.log(data)

                let r = data.split("\n").slice(0, -1); // last item is empty because elephant double returns at the end
                try {
                    elephantSocket.results(r.map(e => JSON.parse(e)["item"]));
                } catch (e) {
                    console.error("Failed to parse JSON output:", e);
                }
            }
        }
    }

    function query(providers: list<string>, query: string, limit: int, callback: var) {
        let q = [providers.join(","), query, limit].join(";");

        elephantSocket.write(q)
        elephantSocket.flush()

        /*var handler = function (results) {
            elephantSocket.results.disconnect(handler);
            callback(results);
        };
        elephantSocket.results.connect(handler);*/
    }

    function queryProviders() {
        query(["providerlist"], "", 30, r => root.providers = r);
    }
}
