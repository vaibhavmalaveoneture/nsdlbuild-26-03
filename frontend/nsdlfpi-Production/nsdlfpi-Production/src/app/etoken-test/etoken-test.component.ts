import { Component, OnInit } from '@angular/core';
import { ETokenServiceService } from './etoken-service.service';

@Component({
  selector: 'app-etoken-test',
  standalone: false,
  templateUrl: './etoken-test.component.html',
  styleUrl: './etoken-test.component.scss'
})


export class EtokenTestComponent implements OnInit {
  certificates: string[] = [];

  constructor(private eTokenService: ETokenServiceService) {}

  ngOnInit() {
    this.certificates = this.eTokenService.getCertificates();
  }
}
