export function openDropdown (isDropdownOpen, dropdownButtonElem, dropdownContentElem, enableAutoScroll = false) {

    if (dropdownContentElem && dropdownButtonElem && !isDropdownOpen) {

        dropdownButtonElem.classList.remove("rotate-180");
        dropdownContentElem.classList.remove("animate-collapse");
        dropdownContentElem.classList.add("animate-expand");

        // Clean up any existing animation state
        cleanupAnimationState(dropdownContentElem);

        if(!dropdownContentElem.getAttribute('data-height')) {
            const fullHeight = dropdownContentElem.offsetHeight;
            dropdownContentElem.setAttribute('data-height', fullHeight);
            const duration = calcAnimTime(dropdownContentElem);
            dropdownContentElem.style.animationDuration = `${duration}ms`;
            addAnimationEventListeners(dropdownContentElem, enableAutoScroll);
        } else {
            const duration = calcAnimTime(dropdownContentElem);
            dropdownContentElem.style.animationDuration = `${duration}ms`;
            addAnimationEventListeners(dropdownContentElem, enableAutoScroll);
        }

        return true;
    };
};

export function closeDropdown (isDropdownOpen, dropdownButtonElem, dropdownContentElem, enableAutoScroll = false) {

    if (dropdownContentElem && dropdownButtonElem && isDropdownOpen) {
        dropdownContentElem.setAttribute('data-height', dropdownContentElem.offsetHeight);
        dropdownButtonElem.classList.add("rotate-180");
        dropdownContentElem.classList.remove("animate-expand");
        dropdownContentElem.classList.add("animate-collapse");

        // Clean up any existing animation state
        cleanupAnimationState(dropdownContentElem);
        addAnimationEventListeners(dropdownContentElem, enableAutoScroll);

        return false;
    };
};

function cleanupAnimationState(dropdownContentElem) {
    // Cancel any existing animation frame
    const existingFrameId = dropdownContentElem._animationFrameId;
    if (existingFrameId) {
        cancelAnimationFrame(existingFrameId);
        dropdownContentElem._animationFrameId = null;
    }

    // Reset state attributes
    dropdownContentElem.removeAttribute('data-isOpen');
    dropdownContentElem.removeAttribute('data-isClosed');

    // Remove existing event listeners if they exist
    if (dropdownContentElem._eventHandlers) {
        const handlers = dropdownContentElem._eventHandlers;
        dropdownContentElem.removeEventListener('animationstart', handlers.expandStart);
        dropdownContentElem.removeEventListener('animationend', handlers.expandEnd);
        dropdownContentElem.removeEventListener('animationcancel', handlers.expandCancel);
        dropdownContentElem.removeEventListener('animationstart', handlers.collapseStart);
        dropdownContentElem.removeEventListener('animationend', handlers.collapseEnd);
        dropdownContentElem.removeEventListener('animationcancel', handlers.collapseCancel);
        dropdownContentElem._eventHandlers = null;
    }
}

function addAnimationEventListeners (dropdownContentElem, enableAutoScroll = false) {
    const animatedElem = dropdownContentElem;
    const headerOffset = 68;
    let elementPosition = animatedElem.getBoundingClientRect().top;
    let offsetPosition = elementPosition + window.scrollY - headerOffset;

    let animationActive = false;
    let frameId = null;
    let elementIsExpanded = false;

    function scrollAnimate() {
        window.scrollTo({
            top: offsetPosition,
        })
        if (animationActive) {
            frameId = requestAnimationFrame(scrollAnimate);
            dropdownContentElem._animationFrameId = frameId;
        }
    }

    // Event handlers stored for later removal
    const handlers = {
        expandStart: function(anim) {
            if (anim.animationName === "expand") {
                dropdownContentElem.setAttribute('data-isOpen', 'true');
                if (enableAutoScroll) {
                    frameId = requestAnimationFrame(scrollAnimate);
                    dropdownContentElem._animationFrameId = frameId;
                    animationActive = true;
                }
            }
        },
        expandEnd: function(anim) {
            if (anim.animationName === 'expand') {
                if (enableAutoScroll && frameId) {
                    cancelAnimationFrame(frameId);
                    dropdownContentElem._animationFrameId = null;
                }
                animationActive = false;
                elementIsExpanded = true;
            }
        },
        expandCancel: function(anim) {
            if (anim.animationName === 'expand') {
                if (enableAutoScroll && frameId) {
                    cancelAnimationFrame(frameId);
                    dropdownContentElem._animationFrameId = null;
                }
                animationActive = false;
                elementIsExpanded = true;
            }
        },
        collapseStart: function(anim) {
            if (anim.animationName === 'collapse') {
                dropdownContentElem.setAttribute('data-isClosed', 'true');
            }
        },
        collapseEnd: function(anim) {
            if (anim.animationName === 'collapse') {
                elementIsExpanded = false;
            }
        },
        collapseCancel: function(anim) {
            if (anim.animationName === 'collapse') {
                if (enableAutoScroll && frameId) {
                    cancelAnimationFrame(frameId);
                    dropdownContentElem._animationFrameId = null;
                }
                elementIsExpanded = false;
            }
        }
    };

    // Store handlers for cleanup
    dropdownContentElem._eventHandlers = handlers;

    // Add event listeners
    dropdownContentElem.addEventListener('animationstart', handlers.expandStart);
    dropdownContentElem.addEventListener('animationend', handlers.expandEnd);
    dropdownContentElem.addEventListener('animationcancel', handlers.expandCancel);
    dropdownContentElem.addEventListener('animationstart', handlers.collapseStart);
    dropdownContentElem.addEventListener('animationend', handlers.collapseEnd);
    dropdownContentElem.addEventListener('animationcancel', handlers.collapseCancel);
}

function calcAnimTime(dropdownContentElem) {
    const elemHeight = parseFloat(dropdownContentElem.getAttribute('data-height')) || 0;

    const baseDuration = 500;
    const minDuration = 200;
    const maxDuration = 1200;
    const scalingFactor = 0.50;

    const timeDuration = Math.min(
        Math.max(baseDuration * Math.pow((elemHeight / 500), scalingFactor), minDuration),
        maxDuration
    );

    return Math.max(timeDuration, 100);
}
