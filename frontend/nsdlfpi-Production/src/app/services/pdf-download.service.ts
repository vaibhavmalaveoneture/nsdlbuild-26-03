import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class PdfService {
  private baseUrl = `${environment.BASE_PATH}/api/pdf`;

  constructor(private http: HttpClient) {}

  generateAndDownload(applicationId: string): Observable<Blob> {
    const params = new HttpParams().set('applicationId', applicationId);
    // const headers = new HttpHeaders().set('Accept', 'application/pdf');
    const token = localStorage.getItem('token') ?? '';

    const headers = new HttpHeaders({
      Authorization: `Bearer ${token}`,
      Accept: 'application/pdf'
    });


    return this.http.post(`${this.baseUrl}/GenerateAndDownload`, {}, {
      params,
      headers,
      responseType: 'blob', // Important: For PDF binary
    });
  }

  generateCertificatePdf(applicationId: string): Observable<Blob> {
    const params = new HttpParams().set('applicationId', applicationId);
    const token = localStorage.getItem('token') ?? '';

    const headers = new HttpHeaders({
      Authorization: `Bearer ${token}`,
      Accept: 'application/pdf'
    });



    return this.http.post(`${this.baseUrl}/GenerateCertificatePdf`, {}, {
      params,
      headers,
      responseType: 'blob',
    });
  }
}