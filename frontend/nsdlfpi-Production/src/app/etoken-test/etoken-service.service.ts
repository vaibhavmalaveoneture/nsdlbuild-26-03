import { Injectable } from '@angular/core';

declare var ActiveXObject: any;

@Injectable({
  providedIn: 'root',
})

export class ETokenServiceService {
  getCertificates(): string[] {
    let certificates: string[] = [];

    try {
      const certStore = new ActiveXObject('CAPICOM.Store');
      certStore.Open(2, 'My', 0); // Open Personal Certificate Store

      const certs = certStore.Certificates;
      for (let i = 1; i <= certs.Count; i++) {
        let cert = certs.Item(i);
        certificates.push(cert.SubjectName); // Get Subject Name
      }
    } catch (error) {
      console.error('Error accessing certificates:', error);
    }

    return certificates;
  }
}
