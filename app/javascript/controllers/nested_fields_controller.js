import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
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
}
