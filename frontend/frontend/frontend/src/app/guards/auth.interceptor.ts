// auth.interceptor.ts
import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpInterceptor,
  HttpHandler,
  HttpRequest,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { Router } from '@angular/router';
import { MessageService } from 'primeng/api';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(
    private router: Router,
    private messageService: MessageService
  ) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return next.handle(req).pipe(
      catchError((err: HttpErrorResponse) => {
        if (err.status === 401) {
          this.messageService.add({
            severity: 'error',
            summary: 'Session Expired',
            detail: 'Your session has expired. Please log in again.',
            life: 3000
          });

          // Optionally wait a second before redirecting
          setTimeout(() => {
            // Clear session/local storage
            localStorage.clear();
            sessionStorage.clear();

            // Navigate to login page
            this.router.navigate(['/landing']);
          }, 1000);
        }

        return throwError(() => err);
      })
    );
  }
}
