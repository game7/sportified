import { bindable, inject } from 'aurelia-framework';

import $                    from 'jquery';
import 'bootstrap-colorpicker';


@inject(Element)
export class ProgramSelectorCustomElement {

  @bindable program;

  constructor(Element) {
    this.element = Element;
  }

  attached() {
    let input = $(this.element).find('.color');
    let program = this.program;
    $(this.element).find('.input-group').colorpicker({
      input: input,
    }).on('changeColor', (e) => {
      program.color = e.color.toHex();
    });
  }

}
