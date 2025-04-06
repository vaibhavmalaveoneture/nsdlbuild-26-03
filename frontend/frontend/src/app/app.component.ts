import { Component, HostListener } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  standalone: false,
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'nsdl-fpi';

  @HostListener('document:contextmenu', ['$event'])
  // onRightClick(event: MouseEvent) {
  //   event.preventDefault();
  // }

  // Disable Ctrl+C, Ctrl+V, Ctrl+X
  @HostListener('document:keydown', ['$event'])
  onKeyDown(event: KeyboardEvent) {
    if ((event.ctrlKey || event.metaKey) && ['c', 'v', 'x', 'a'].includes(event.key.toLowerCase())) {
      event.preventDefault();
    }
  }
}
