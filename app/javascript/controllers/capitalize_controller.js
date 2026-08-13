import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  format(event) {
    let value = event.target.value
    // Expressão regular que pega a primeira letra da string e qualquer letra após um espaço
    event.target.value = value.replace(/(^\w{1})|(\s+\w{1})/g, letter => letter.toUpperCase())
  }
}