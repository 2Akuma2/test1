// Use this file to customize the QF-Test HTML report

document.addEventListener("DOMContentLoaded", function(event) {
    // Attach simple modals to image links and truncated error messages
    var modalTriggers = document.querySelectorAll('a[href$=".png"], textarea');

    modalTriggers.forEach(trigger => {
        trigger.dataset.modalTriggerId = Math.random().toString(36).substr(2, 9);
        prevTrigger = modalTriggers?.[Array.from(modalTriggers).indexOf(trigger) - 1];
        nextTrigger = modalTriggers?.[Array.from(modalTriggers).indexOf(trigger) + 1];
        attachModal(trigger, prevTrigger, nextTrigger);
    });

    // Modal Keyboard navigation
    document.body.addEventListener('keydown', (keyEvent) => {
        modal = document.querySelector("#modal");
        if (!modal) {
            return;
        }
        if (keyEvent.key == "Escape") {
            // Close modal overlay on Escape
            trigger = document.querySelector(`[data-modal-trigger-id="${modal.dataset.trigger}"]`);
            if (trigger) {
                closeModal(modal, trigger);
                keyEvent.stopPropagation();
            }
        } else if (keyEvent.key == "ArrowLeft" || keyEvent.key == "ArrowUp") {
            prevTrigger = document.querySelector(`[data-modal-trigger-id="${modal.dataset.prevTrigger}"]`);
            if (prevTrigger) {
                switchModal(modal, prevTrigger);
                keyEvent.stopPropagation();
            }
        } else if (keyEvent.key == "ArrowRight" || keyEvent.key == "ArrowDown") {
            nextTrigger = document.querySelector(`[data-modal-trigger-id="${modal.dataset.nextTrigger}"]`);
            if (nextTrigger) {
                switchModal(modal, nextTrigger);
                keyEvent.stopPropagation();
            }
        }
    });
});

/**
 * Attach a modal overlay to the given trigger, with next/previous navigation
 *
 * @param {Element} trigger
 * @param {Element} prevTrigger
 * @param {Element} nextTrigger
 * @returns {Element}
 */
function attachModal(trigger, prevTrigger, nextTrigger) {
    const lastDown = {};
    trigger.addEventListener("mousedown", (downEvent) => {
        lastDown.x = downEvent.clientX;
        lastDown.y = downEvent.clientY;
    });
    trigger.addEventListener("click", (clickEvent) => {
        if (trigger.tagName == "TEXTAREA") {
            const realClick = clickEvent.clientX > 0 || clickEvent.clientY > 0;
            if (realClick && (Math.abs(clickEvent.clientX - lastDown.x) > 5 || Math.abs(clickEvent.clientY - lastDown.y) > 5)) {
                return; // don't open modal on textarea select/resize
            }
        }
        
        clickEvent.preventDefault();
        modal = document.createElement("div");
        modal.id = "modal";
        modal.dataset.trigger = trigger.dataset.modalTriggerId;
        if (prevTrigger) {
            modal.dataset.prevTrigger = prevTrigger.dataset.modalTriggerId;
        }
        if (nextTrigger) {
            modal.dataset.nextTrigger = nextTrigger.dataset.modalTriggerId;
        }

        modal.appendChild(modalContent(trigger, prevTrigger, nextTrigger, modal));

        trigger.focus();
        document.body.appendChild(modal);
    });
}

/**
 * @param {Element} modal
 */
function closeModal(modal, trigger) {
    // Remove from DOM
    modal.remove();
}

function switchModal(modal, nextModalTrigger) {
    modal.remove();
    nextModalTrigger.click();
    // Scroll the current trigger link into view
    navigationBarOffset = 85;
    window.scrollTo({
        top: nextModalTrigger.getBoundingClientRect().top + window.pageYOffset - navigationBarOffset,
        behavior: "smooth"
    });
        // Give the current trigger link a
    // focus ring to orientate the user.
    nextModalTrigger.focus();
}

/**
 *
 * @param {Element} trigger
 * @param {Element} prevTrigger
 * @param {Element} nextTrigger
 * @param {Element} modal
 * @returns {Element}
 */
function modalContent(trigger, prevTrigger, nextTrigger, modal) {
    var container = document.createElement("DIV");
    container.id = "modal-container";

    var close = document.createElement("BUTTON");
    close.id = "modal-close";
    close.textContent = "×";
    close.title = "Close";
    close.onclick = () => {
        closeModal(modal, trigger);
    }
    container.appendChild(close);

    var prevButton = document.createElement("BUTTON");
    prevButton.id = "modal-prev";
    prevButton.textContent = "‹";
    prevButton.title = "Previous";
    if (prevTrigger) {
        prevButton.onclick = () => {
            switchModal(modal, prevTrigger);
        }
    } else {
        prevButton.setAttribute("disabled", 1);
    }
    container.appendChild(prevButton);

    if (trigger.tagName == "A") {
        var imgTitle = trigger.textContent ? trigger.textContent : trigger.querySelector("img").getAttribute("title");
        var imgUrl = trigger.getAttribute("href");
        var modalContent = document.createElement("DIV");
        modalContent.id = "modal-content";
        modalContent.innerHTML = `
        <div id="modal-content-desc">${imgTitle + ": " +  imgUrl}</div>
        <div id="imgwrapper">
            <img alt="${imgTitle}" src="${imgUrl}" />
        </div>
        `;
        container.appendChild(modalContent);
    } else if (trigger.tagName == "TEXTAREA") {
        var modalContent = document.createElement("DIV");
        modalContent.id = "modal-content"
        modalContent.innerHTML = `
        <textarea readonly="">${trigger.value}</textarea>
        `;
        container.appendChild(modalContent);
    }

    var nextButton = document.createElement("BUTTON");
    nextButton.id = "modal-next";
    nextButton.textContent = "›";
    nextButton.title = "Next";
    if (nextTrigger) {
        nextButton.onclick = () => {
            switchModal(modal, nextTrigger);
        }
    } else {
        nextButton.setAttribute("disabled", 1);
    }
    container.appendChild(nextButton);

    return container;
}