// Self-executing modules (run automatically on import)
import './modules/tabs.js';

// Modules with exported functionality (imported as namespaces)
import * as cinemaModule from './modules/cinemamodule.js';
import * as sidebarToggle from './modules/sidebartoggle.js';
import * as dropdownToggle from './modules/dropdowntoggle.js';
import * as touchscreenutilities from './modules/touchscreenutilities.js';
import * as audioMotionModule from './modules/audiomotion.js';
import * as urlStateManager from './modules/url-state-manager.js';

import Plyr from 'plyr';
import Hammer from 'hammerjs';
import {toggleTextBox} from "./modules/cinemamodule.js";

document.addEventListener('DOMContentLoaded', () => {
    // HANDLE INTERACTIONS WITH PROJECT OVERLAY BUTTONS
    const projectOverlays = document.querySelectorAll("[id^='project-overlay-']");
    const linkOverlaysBtns = document.querySelectorAll("[id^='link-overlay-btn-']");

    projectOverlays.forEach((projectOverlay, index) => {
        if (projectOverlay.isHovering === undefined) {
            projectOverlay.isHovering = false;
        }
        const parentLink = projectOverlay.closest('a');
        const hammerProjectBtn = new Hammer(parentLink);

        parentLink.addEventListener('click', (e) => {
            // THIS CONDITION SHOULD BE REDUNDANT BUT FOR SOME REASON IT IS NEEDED.
            if(touchscreenutilities.isTouchDevice()) {
                e.preventDefault();
            }
        })
        projectOverlay.addEventListener('mouseover', () => {
            touchscreenutilities.applyOverlay(projectOverlay);
        })
        projectOverlay.addEventListener('mouseout', () => {
            touchscreenutilities.removeOverlay(projectOverlay);
        })
        hammerProjectBtn.on('tap', () => {
            if (!projectOverlay.isHovering) {
                linkOverlaysBtns[index].classList.remove('opacity-80');
                linkOverlaysBtns[index].classList.add('opacity-100');
                touchscreenutilities.applyTouchHoverEffect(projectOverlay);
            } else {
                linkOverlaysBtns[index].classList.remove('opacity-80');
                linkOverlaysBtns[index].classList.add('opacity-100');
                setTimeout(() => {
                    window.open(parentLink.href, '_blank', 'noopener,noreferrer');
                }, 15);
            }
        });
        if(touchscreenutilities.isTouchDevice()) {
            projectOverlay.addEventListener('touchstart', () => {
                linkOverlaysBtns[index].classList.remove('opacity-100');
                linkOverlaysBtns[index].classList.add('opacity-80');
            });
            document.addEventListener('touchend', () => {
                linkOverlaysBtns[index].classList.remove('opacity-80');
                linkOverlaysBtns[index].classList.add('opacity-100');
            });
        } else {
            projectOverlay.addEventListener('mousedown', () => {
                if (projectOverlay.isHovering) {
                    linkOverlaysBtns[index].classList.remove('opacity-100');
                    linkOverlaysBtns[index].classList.add('opacity-80');
                }
            })
            document.addEventListener('mouseup', () => {
                linkOverlaysBtns[index].classList.remove('opacity-80');
                linkOverlaysBtns[index].classList.add('opacity-100');
            })
        }
    });

    // Initialize default Plyr for all video elements with the class 'plyr-video' applied
    //PLYR VIDEO PLAYERS (DEFAULT)
    const videoPlayers = Plyr.setup('.plyr-video', {
        controls: ['play-large', 'play', 'progress', 'current-time', 'mute', 'volume', 'captions', 'settings', 'pip', 'airplay', 'fullscreen',],
        keyboard: {
            focused: true,
            global: false,
        },
        volume: 0.8,
    });

    // Hide overlay text when a video starts playing; show it again on pause/end
    videoPlayers.forEach(player => {
        try {
            const plyrContainer = player.elements.container; // .plyr wrapper inserted by Plyr
            const relativeContainer = plyrContainer && plyrContainer.parentElement;
            if (!relativeContainer) return;
            // Both portfolio and showreel overlays share pointer-events-none and absolute positioning
            const overlay = relativeContainer.querySelector('.absolute.pointer-events-none');
            if (!overlay) return;

            // Ensure smooth opacity transitions if Tailwind utilities are available
            overlay.classList.add('transition-opacity');
            // Use a conservative duration utility if Tailwind is present; otherwise browser defaults will ignore it
            overlay.classList.add('duration-300');

            const hideOverlay = () => overlay.classList.add('opacity-0');
            const showOverlay = () => overlay.classList.remove('opacity-0');

            // Bind to Plyr events
            player.on('play', hideOverlay);
            player.on('pause', showOverlay);
            player.on('ended', showOverlay);
        } catch (e) {
            // Fail silently to avoid breaking other scripts
            // console.debug('Overlay toggle setup failed', e);
        }
    });

    // PLYR MUSIC VIDEO PLAYERS
    const musicVideoPlayers = Plyr.setup('.plyr-musicvideo', {
        controls: ['play-large', 'play', 'progress', 'current-time', 'mute', 'volume', 'settings',],
        keyboard: {
            focused: true,
            global: false,
        },
        volume: 0.8,
        storage: {
            enabled: false
        }
    })

    // HANDLE TOUCH INTERACTIONS WITH VIDEO PLAYERS
    if(touchscreenutilities.isTouchDevice()) {
        const allVideoPlayers = videoPlayers.concat(musicVideoPlayers);
        allVideoPlayers.forEach(player => {
            const playerElement = player.elements.container;
            const hammerVideoBtn = new Hammer(playerElement);
            hammerVideoBtn.on('tap', (e) => {
                if (e.target.closest('.plyr__controls')) {
                    e.stopPropagation();
                } else {
                    if (player.playing) {
                        player.pause();
                    }
                }
            });
        });
    }

    // PLYR AUDIO PLAYERS
    // Initialize default Plyr for all audio elements with the class 'plyr-audio' applied
    const audioPlayers = Plyr.setup('.plyr-audio', {
        volume: 0.8,
        seekTime: 10,
        controls: ['play', 'progress', 'volume', 'mute'],
        disableContextMenu: true,
        storage: {
            enabled: false
        }
    });

    const pageAttribute = document.body.getAttribute("data-page");
    const musicPageActive = pageAttribute && (pageAttribute === "index_page");
    if (!musicPageActive) {
        return;
    }

    // HANDLE INTERACTIONS WITH MUSIC OVERLAY BUTTONS
    const playMusicOverlays = document.querySelectorAll("[id^='play-music-overlay-']");
    // const musicOverlaysBtns = document.querySelectorAll("[id^='play-music-btn-']");
    playMusicOverlays.forEach((musicOverlay, index) => {
        const musicOverlayID = musicOverlay.getAttribute('id');
        const customIndex = musicOverlayID.charAt(musicOverlayID.length - 1);
        const musicOverlaysBtns = document.querySelector(`[id^='play-music-btn-${customIndex}']`);

        if (musicOverlay.isHovering === undefined) {
            musicOverlay.isHovering = false;
        }
        musicOverlay.addEventListener('mouseover', () => {
            touchscreenutilities.applyOverlay(musicOverlay);
        })
        musicOverlay.addEventListener('mouseout', () => {
            touchscreenutilities.removeOverlay(musicOverlay);
        })

        const playMusicBtn = document.querySelector(`#play-music-overlay-${customIndex}`);
        const ionIconElem = playMusicBtn.querySelector('ion-icon');
        const hammerMusicBtn = new Hammer(playMusicBtn);

        if (playMusicBtn) {
            hammerMusicBtn.on('tap', () => {
                if(musicOverlay.isHovering) {
                    if (!audioPlayers[index].playing) {
                        audioPlayers[index].play();
                    } else if (audioPlayers[index].playing) {
                        audioPlayers[index].pause();
                    }
                } else {
                    touchscreenutilities.applyTouchHoverEffect(musicOverlay);
                }
            })


            if(touchscreenutilities.isTouchDevice()) {
                playMusicBtn.addEventListener('touchstart', () => {
                    musicOverlaysBtns.classList.remove('opacity-100');
                    musicOverlaysBtns.classList.add('opacity-80');
                });
                playMusicBtn.addEventListener('touchend', () => {
                    musicOverlaysBtns.classList.remove('opacity-80');
                    musicOverlaysBtns.classList.add('opacity-100');
                });
            } else {
                playMusicBtn.addEventListener('mousedown', () => {
                    if (musicOverlay.isHovering) {
                        musicOverlaysBtns.classList.remove('opacity-100');
                        musicOverlaysBtns.classList.add('opacity-80');
                    }
                })
                playMusicBtn.addEventListener('mouseup', () => {
                    musicOverlaysBtns.classList.remove('opacity-80');
                    musicOverlaysBtns.classList.add('opacity-100');
                })
            }
        }

        audioPlayers[index].on('play', () => {
            ionIconElem.setAttribute('name', 'pause');
        })
        audioPlayers[index].on('pause', () => {
            ionIconElem.setAttribute('name', 'play');
        })
        audioPlayers[index].on('end', () => {
            ionIconElem.setAttribute('name', 'play');
        })

        // ADDING AUDIO VISUALIZATION TO AUDIO SETUP
        if(!touchscreenutilities.isTouchDevice()) {
            let audioMotion;
            let isPlaying = false;
            let isPaused = true;
            let isSeeking = false;
            let pauseTime = 0;
            let seekPause = false;

            const audioContainer = document.querySelector(`#audioContainer-${customIndex}`);
            audioPlayers[index].on('play', () => {
                if (isPlaying) return;

                if (!audioMotion) {
                    audioMotion = audioMotionModule.createAudioMotionInstance(audioContainer, audioPlayers[index]);
                    audioMotionModule.audioMotionFadeIn(audioMotion);
                }

                isPlaying = true;
                isPaused = false;

                if (!seekPause) {
                    audioMotionModule.audioMotionFadeIn(audioMotion);
                } else {
                    seekPause = false;
                }
            });

            audioPlayers[index].on('pause', () => {
                if (isPaused) return;

                isPaused = true;
                isPlaying = false;

                pauseTime = Date.now();

                setTimeout(() => {
                    if(!seekPause) {
                        audioMotionModule.pauseAudioMotionInstance(audioMotion);
                    }
                }, 10);
            });

            audioPlayers[index].on('seeking', () => {
                isSeeking = true;

                const currentTime = Date.now();
                if (currentTime - pauseTime < 5) {
                    seekPause = true;
                }
            });
        }
    });

    // MAKE SURE NO PLAYERS PLAY SIMULTANEOUSLY
    const allPlyrPlayers = videoPlayers.concat(musicVideoPlayers, audioPlayers);
    allPlyrPlayers.forEach(player => {
        player.on('play', async () => {
            for (let otherPlayer of allPlyrPlayers) {
                if (otherPlayer !== player &&  !otherPlayer.paused) {
                    otherPlayer.pause();
                }
            }
        });
    });
});

// VIDEO TOGGLE
// document.addEventListener("DOMContentLoaded", () => {
//     const videocontainer = document.getElementById('showreelvideocontainer');
//     const video = document.querySelector('#reel-container');
//     const button = document.getElementById("showreelbutton");
//     const closeReelButton = document.getElementById("close-reel-button");
//     const delayTime = 500;
//     let timerActive = false;
//
//     const showreelPageActive = (document.body.getAttribute("data-page").toLowerCase() === "home") || false;
//
//     if (!showreelPageActive)
//         return;
//
//     const toggleShowreel = () => {
//         if (timerActive)
//             return;
//         const isShowreelOn = cinemaModule.togglevideo(delayTime);
//         cinemaModule.overlayToggle();
//         cinemaModule.showreelButtonState(delayTime);
//         cinemaModule.toggleTextBox();
//
//         console.log(isShowreelOn);
//         urlStateManager.updateURL(isShowreelOn);
//
//         timerActive = true;
//         setTimeout(() => {
//             timerActive = false;
//         }, delayTime);
//     }
//
//     document.addEventListener("keydown", (keydownEvent) => {
//         if (keydownEvent.key === "Escape" && videocontainer.classList.contains("grid")) {
//             toggleShowreel()
//         }
//     });
//
//     button.addEventListener("click", toggleShowreel);
//     closeReelButton.addEventListener("click", toggleShowreel);
//
//     window.addEventListener("click", (clickEvent) => {
//         if (!video.contains(clickEvent.target) && videocontainer.classList.contains("grid")){
//             toggleShowreel()
//         }
//     });
//
//     window.addEventListener("popstate", toggleShowreel);
//
//     // on page load start video if url matches "on" state
//     const urlParams = new URLSearchParams(window.location.search);
//     if (urlParams.get("home") === "on") {
//         cinemaModule.togglevideo(delayTime);
//         cinemaModule.overlayToggle();
//         cinemaModule.showreelButtonState(delayTime);
//     }
// });

// NAV SIDEBAR TOGGLE
document.addEventListener("DOMContentLoaded", () => {
    const closeMenuButton = document.getElementById("closemenubutton");
    const menuButton = document.getElementById("openmenubutton");
    const sidebar = document.getElementById("sidebarnav");

    let sidebarOpen = false;

    menuButton.addEventListener("click", () => (!sidebarOpen) ? sidebarOpen = sidebarToggle.openMenu(sidebarOpen) : sidebarOpen = sidebarToggle.closeMenu(sidebarOpen));
    closeMenuButton.addEventListener("click", () => (sidebarOpen) ? sidebarOpen = sidebarToggle.closeMenu(sidebarOpen) : sidebarOpen = sidebarToggle.openMenu(sidebarOpen));

    document.addEventListener("click", (clickEvent) => {
        if (!sidebarOpen) {
            return;
        } else if (!sidebar.contains(clickEvent.target) && !menuButton.contains(clickEvent.target)) {
            sidebarOpen = sidebarToggle.closeMenu(sidebarOpen);
        }
    });

    addEventListener("resize", () => {
        const width = window.innerWidth;
        if (width > 640)
            {
                sidebarOpen = sidebarToggle.closeMenu(sidebarOpen);
            }
    });
});

// DROPDOWN CONTENT TOGGLE - ABOUT PAGE
document.addEventListener("DOMContentLoaded", () => {
    const aboutPageActive = (document.body.getAttribute("data-page") === "about_page") || false;
    if (!aboutPageActive)
        return;

    const resumeContentElem = document.getElementsByClassName("resume-content");
    const dropdownStates = [];

    for (const elem of resumeContentElem) {
        const buttonContainerElem = elem.firstElementChild.firstElementChild;

        const buttonElemIDs = buttonContainerElem.querySelector("button").id;
        const contentElemIDs = elem.children[1]?.firstElementChild.id;

        const dropdownButtonElem = document.getElementById(buttonElemIDs);
        const dropdownContentElem = document.getElementById(contentElemIDs);

        const dropdownState = {
            isOpen: false,
            buttonElem: dropdownButtonElem,
            contentElem: dropdownContentElem
        };
        dropdownStates.push(dropdownState);

        buttonContainerElem.addEventListener("click", () => {
            // If opening a dropdown, close all others first
            if (!dropdownState.isOpen) {
                dropdownStates.forEach(state => {
                    if (state !== dropdownState && state.isOpen) {
                        state.isOpen = dropdownToggle.closeDropdown(state.isOpen, state.buttonElem, state.contentElem, true);
                    }
                });
                dropdownState.isOpen = dropdownToggle.openDropdown(dropdownState.isOpen, dropdownButtonElem, dropdownContentElem, true);
            } else {
                dropdownState.isOpen = dropdownToggle.closeDropdown(dropdownState.isOpen, dropdownButtonElem, dropdownContentElem, true);
            }
        });
    }
});

// DROPDOWN CONTENT TOGGLE - SCRIPTS PAGE
document.addEventListener("DOMContentLoaded", () => {
    const scriptsPageActive = (document.body.getAttribute("data-page") === "scripts_page") || false;
    if (!scriptsPageActive)
        return;

    const scriptContentElem = document.getElementsByClassName("script-content");
    const dropdownStates = [];

    for (const elem of scriptContentElem) {
        const buttonContainerElem = elem.firstElementChild.firstElementChild;

        const buttonElemIDs = buttonContainerElem.querySelector("button").id;
        const contentElemIDs = elem.children[1]?.firstElementChild.id;

        const dropdownButtonElem = document.getElementById(buttonElemIDs);
        const dropdownContentElem = document.getElementById(contentElemIDs);

        const dropdownState = {
            isOpen: false,
            buttonElem: dropdownButtonElem,
            contentElem: dropdownContentElem
        };
        dropdownStates.push(dropdownState);

        buttonContainerElem.addEventListener("click", () => {
            // If opening a dropdown, close all others first
            if (!dropdownState.isOpen) {
                dropdownStates.forEach(state => {
                    if (state !== dropdownState && state.isOpen) {
                        state.isOpen = dropdownToggle.closeDropdown(state.isOpen, state.buttonElem, state.contentElem, false);
                    }
                });
                dropdownState.isOpen = dropdownToggle.openDropdown(dropdownState.isOpen, dropdownButtonElem, dropdownContentElem, false);
            } else {
                dropdownState.isOpen = dropdownToggle.closeDropdown(dropdownState.isOpen, dropdownButtonElem, dropdownContentElem, false);
            }
        });
    }
});