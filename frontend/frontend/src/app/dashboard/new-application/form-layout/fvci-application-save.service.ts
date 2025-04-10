import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class FvciApplicationSaveService {
  // private baseUrl = '`${environment.BASE_PATH}`/api/application';
  private baseUrl = `${environment.BASE_PATH}/api/application`

  constructor(private http: HttpClient) {}

  /**
   * Save or update the FVCI application data
   * @param payload The full application data object
   * @param token The JWT token
   */
  saveOrUpdateApplication(payload: any, token: string): Observable<any> {
    const url = `${this.baseUrl}/SaveOrUpdateApplication`;
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      Accept: '*/*',
      Authorization: `Bearer ${token}`,
    });
    return this.http.post(url, payload, { headers });
  }


  /**
   * Save or update the FVCI application data
   * @param payload The full application data object
   * @param token The JWT token
   */
  updateApplication(payload: any, token: string): Observable<any> {
    const url = `${this.baseUrl}/UpdateApplication`;
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      Accept: '*/*',
      Authorization: `Bearer ${token}`,
    });
    return this.http.post(url, payload, { headers });
  }

  /**
   * Fetch FVCI application by ID
   * @param applicationId Application ID
   * @param token The JWT token
   */
  getFvciApplicationById(applicationId: string | number, token: string): Observable<any> {
    const url = `${this.baseUrl}/GetFvciApplicationByIdAsync?applicationId=${applicationId}`;
    const headers = new HttpHeaders({
      Accept: '*/*',
      Authorization: `Bearer ${token}`,
    });
    return this.http.get(url, { headers });
  }

   /**
   * Fetch FVCI application by ID
   * @param token The JWT token
   */
   getFvciApplicationForATS( token: string): Observable<any> {
    const url = `${this.baseUrl}/GetApplicationForATS`;
    const headers = new HttpHeaders({
      Accept: '*/*',
      Authorization: `Bearer ${token}`,
    });
    return this.http.get(url, { headers });
  }
}