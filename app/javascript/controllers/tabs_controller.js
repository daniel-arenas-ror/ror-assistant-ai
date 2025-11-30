import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "header", "body" ]

  initialize() {
    this.index = 1
    this.showCurrentSlide()
  }

  next(event) {
    this.index++
    event.preventDefault()
    this.showCurrentSlide()
  }

  previous(event) {
    this.index--
    event.preventDefault()
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.cleanActiveClasses();

    this.headerTargets.forEach((element) => {
      if (element.dataset.step == this.index){
        element.classList.add("form-stepper__step--active")
      }
    })

    document
        .querySelector(`[data-step-content="${this.index}"]`)
        .classList.add("form-stepper__content-pane--active");
  }

  switch(event) {
    this.index = event.currentTarget.dataset.step;
    this.showCurrentSlide()
  }

  cleanActiveClasses() {
    this.headerTargets.forEach((element) => {
      element.classList.remove("form-stepper__step--active")
    })

    this.bodyTargets.forEach(el =>
      el.classList.remove("form-stepper__content-pane--active")
    );
  }
}
