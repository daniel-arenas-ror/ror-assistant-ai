import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  switch(event) {
    const tabName = event.currentTarget.dataset.step;

    // nav
    document.querySelectorAll(".form-stepper__step").forEach(el =>
      el.classList.remove("form-stepper__step--active")
    );
    event.currentTarget.classList.add("form-stepper__step--active");

    // content
    document.querySelectorAll(".form-stepper__content-pane").forEach(el =>
      el.classList.remove("form-stepper__content-pane--active")
    );

    document
      .querySelector(`[data-step-content="${tabName}"]`)
      .classList.add("form-stepper__content-pane--active");
  }
}
