import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template"]

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.nested-fields')
    if (!wrapper) return

    const destroyInput = wrapper.querySelector('input[name*="[_destroy]"]')
    if (destroyInput) {
      destroyInput.value = '1'
      wrapper.style.display = 'none'
    } else {
      wrapper.remove()
    }
  }

  add(event) {
    event.preventDefault()
    if (!this.hasListTarget || !this.hasTemplateTarget) return
    const time = new Date().getTime()
    let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, time)
    this.listTarget.insertAdjacentHTML('beforeend', content)
  }
}
