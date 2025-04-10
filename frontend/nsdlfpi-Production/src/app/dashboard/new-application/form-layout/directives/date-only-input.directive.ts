import {
  Directive,
  ElementRef,
  Renderer2,
  AfterViewInit
} from '@angular/core';

@Directive({
  selector: '[appDateOnlyInput], .date-only-input'
})
export class DateOnlyInputDirective implements AfterViewInit {
  constructor(private el: ElementRef, private renderer: Renderer2) {}

  ngAfterViewInit() {
    // Get the actual input element inside p-datepicker
    const inputEl: HTMLInputElement | null = this.el.nativeElement.querySelector('input');

    if (inputEl) {
      this.renderer.setAttribute(inputEl, 'autocomplete', 'off');

      this.renderer.listen(inputEl, 'keypress', (event: KeyboardEvent) => {
        const allowedRegex = /[0-9/]/;
        if (!allowedRegex.test(event.key)) {
          event.preventDefault();
        }
      });

      this.renderer.listen(inputEl, 'paste', (e) => e.preventDefault());
      this.renderer.listen(inputEl, 'copy', (e) => e.preventDefault());
      this.renderer.listen(inputEl, 'cut', (e) => e.preventDefault());
    }
  }
}
