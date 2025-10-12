export const updateURL = (isShowreelOn) => {
    const url = new URL(window.location);
    if (isShowreelOn) {
        url.searchParams.set("home", "on");
    } else {
        url.searchParams.delete("home");
    }
    history.pushState(null, "", url.toString());
}