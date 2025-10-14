export function openMenu (sidebarOpen) {
    const sideBar = document.getElementById("sidebarnav");
    const menuButton = document.getElementById("openmenubutton");

        if (menuButton && sideBar && !sidebarOpen) {
            menuButton.classList.remove("flex");
            menuButton.classList.add("hidden");

            sideBar.classList.remove("animate-slideout");
            sideBar.classList.add("animate-slidein");

            return true;
        }
}

export function closeMenu (sidebarOpen) {
    const closeMenuButton = document.getElementById("closemenubutton");
    const sideBar = document.getElementById("sidebarnav");
    const menuButton = document.getElementById("openmenubutton");

        if (closeMenuButton && sidebarOpen) {
            
            menuButton.classList.remove("hidden");
            sideBar.classList.remove("animate-slidein");
            sideBar.classList.add("animate-slideout");

            return false;
        }
}