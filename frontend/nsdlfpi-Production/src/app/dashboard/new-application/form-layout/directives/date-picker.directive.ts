import { Directive, HostListener } from '@angular/core';

@Directive({
  selector: '[appDateOnlyInput]'
})
export class DateOnlyInputDirective {
  @HostListener('keypress', ['$event']) onKeyPress(event: KeyboardEvent) {
    const allowedRegex = /[0-9/]/;
    if (!allowedRegex.test(event.key)) {
      event.preventDefault();
    }
  }
}