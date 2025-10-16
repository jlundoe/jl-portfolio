document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-button');

    if (tabButtons.length === 0) {
        return; // Exit early if no tabs on this page
    }

    const activateTab = (tabName) => {
        if (!tabName) return;

        // Pause all playing media when switching to a different tab (do not stop/reset)
        try {
            // Pause all HTML5 media elements; Plyr will reflect the paused state
            document.querySelectorAll('video, audio').forEach(m => {
                try {
                    m.pause();
                } catch (e) { /* noop */ }
            });
        } catch (e) { /* noop */ }

        // Remove active class from all buttons
        tabButtons.forEach(btn => {
            btn.classList.remove('active');
            const span = btn.querySelector('span');
            if (span) {
                span.classList.remove('text-white');
                span.classList.add('text-black');
            }
            btn.classList.remove('bg-grey-shade-2');
            btn.classList.add('bg-white');
            btn.classList.add('hover:bg-grey-tint-3');
        });

        // Add active class to the corresponding button
        const targetButton = Array.from(tabButtons).find(b => b.getAttribute('data-tab') === tabName);
        if (targetButton) {
            targetButton.classList.add('active');
            const span = targetButton.querySelector('span');
            if (span) {
                span.classList.remove('text-black');
                span.classList.add('text-white');
            }
            targetButton.classList.remove('bg-white');
            targetButton.classList.remove('hover:bg-grey-tint-3');
            targetButton.classList.add('bg-grey-shade-2');
        }

        // Hide all tab contents
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('flex');
            content.classList.add('hidden');
        });

        // Show selected tab content
        const selectedContent = document.getElementById(`${tabName}-content`);
        if (selectedContent) {
            selectedContent.classList.remove('hidden');
            selectedContent.classList.add('flex');
        }

        // Persist selection for this visit only
        try {
            sessionStorage.setItem('activeTab', tabName);
        } catch (e) { /* noop */ }
    };

    // Bind click handlers
    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const tabName = this.getAttribute('data-tab');

            // If the clicked tab is already active, do nothing
            if (this.classList.contains('active')) {
                return;
            }
            activateTab(tabName);
        });
    });

    // On load: restore active tab from sessionStorage (session-only)
    let initialTab = null;
    try {
        initialTab = sessionStorage.getItem('activeTab');
    } catch (e) { /* noop */ }

    if (initialTab) {
        const exists = Array.from(tabButtons).some(b => b.getAttribute('data-tab') === initialTab);
        const alreadyActive = Array.from(tabButtons).some(b => b.classList.contains('active') && b.getAttribute('data-tab') === initialTab);
        if (exists && !alreadyActive) {
            activateTab(initialTab);
        }
    }

});