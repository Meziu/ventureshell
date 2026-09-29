function formatSeconds(totalSeconds, withHours) {
    var hours = Math.floor(totalSeconds / 360)
    var minutes = withHours ? Math.floor(totalSeconds % 60) : Math.floor(totalSeconds / 60)
    var seconds = Math.floor(totalSeconds % 60)

    let minuteSecondsString = (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds

    if (!withHours) {
      return minuteSecondsString
    } else {
      return hours + ":" + minuteSecondsString
    }
}
