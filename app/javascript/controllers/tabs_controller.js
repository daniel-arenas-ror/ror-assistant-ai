import { Controller } from "@hotwired/stimulus"

const ACTIVE_HEADER_CLASSES = [
  "border-blue-600",
  "text-blue-600",
  "font-semibold"
]

const INACTIVE_HEADER_CLASSES = [
  "border-transparent",
  "text-gray-500"
]

export default class extends Controller {
  static targets = ["header", "body"]

  initialize() {
    console.log("initialize")
    this.index = 1
    this.showCurrentSlide()
  }

  next(event) {
    event.preventDefault()
    if (this.index < this.headerTargets.length) {
      this.index++
      this.showCurrentSlide()
    }
  }

  previous(event) {
    event.preventDefault()
    if (this.index > 1) {
      this.index--
      this.showCurrentSlide()
    }
  }

  switch(event) {
    event.preventDefault()
    this.index = Number(event.currentTarget.dataset.step)
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    const index = Number(this.index)

    this.headerTargets.forEach((element) => {
      element.classList.remove(...ACTIVE_HEADER_CLASSES)
      element.classList.add(...INACTIVE_HEADER_CLASSES)
    })

    this.bodyTargets.forEach((element) => {
      element.classList.add("hidden")
    })

    this.headerTargets.forEach((element) => {
      if (Number(element.dataset.step) === index) {
        element.classList.remove(...INACTIVE_HEADER_CLASSES)
        element.classList.add(...ACTIVE_HEADER_CLASSES)
      }
    })

    const activePane = this.bodyTargets.find(
      (element) => Number(element.dataset.stepContent) === index
    )
    activePane?.classList.remove("hidden")
  }
}
