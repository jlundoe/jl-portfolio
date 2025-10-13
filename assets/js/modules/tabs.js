document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-button');

    if (tabButtons.length === 0) {
        return; // Exit early if no tabs on this page
    }

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const tabName = this.getAttribute('data-tab');

            // Remove active class from all buttons
            tabButtons.forEach(btn => {
                btn.classList.remove('active');
                btn.querySelector('span').classList.remove('text-white');
                btn.querySelector('span').classList.add('text-black');
                btn.classList.remove('bg-grey-shade-1');
                btn.classList.remove('hover:bg-grey-shade-3')
                btn.classList.add('bg-white');
                btn.classList.add('hover:bg-grey-tint-3')
            });

            // Add active class to clicked button
            this.classList.add('active');
            this.querySelector('span').classList.remove('text-black');
            this.querySelector('span').classList.add('text-white');
            this.classList.remove('bg-white');
            this.classList.remove('hover:bg-grey-tint-3');
            this.classList.add('bg-grey-shade-1');
            this.classList.add('hover:bg-grey-shade-3');

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
        });
    });
});