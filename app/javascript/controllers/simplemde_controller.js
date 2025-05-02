import { Controller } from "@hotwired/stimulus"
import SimpleMDE from "simplemde"

export default class extends Controller {
  connect() {
    this.simplemde = new SimpleMDE({
      element: this.element,
      spellChecker: false,
      autoDownloadFontAwesome: true,
      placeholder: "Write your lesson content here...",
      toolbar: [
        "bold",
        "italic",
        "heading",
        "|",
        "quote",
        "unordered-list",
        "ordered-list",
        "|",
        "link",
        "image",
        "|",
        "code",
        "table",
        "|",
        "preview",
        "side-by-side",
        "fullscreen",
        "guide"
      ]
    })
  }

  disconnect() {
    if (this.simplemde) {
      this.simplemde.toTextArea()
      this.simplemde = null
    }
  }
}
