import { NgModule, ModuleWithProviders, SkipSelf, Optional } from '@angular/core';
import { Configuration } from './configuration';
import { HttpClient } from '@angular/common/http';


import { AdminService } from './api/admin.service';
import { AuthService } from './api/auth.service';
import { CommonService } from './api/common.service';
import { DashboardService } from './api/dashboard.service';
import { FvciApplicationService } from './api/fvciApplication.service';
import { NSDLService } from './api/nSDL.service';
import { PdfService } from './api/pdf.service';

@NgModule({
  imports:      [],
  declarations: [],
  exports:      [],
  providers: [
    AdminService,
    AuthService,
    CommonService,
    DashboardService,
    FvciApplicationService,
    NSDLService,
    PdfService ]
})
export class ApiModule {
    public static forRoot(configurationFactory: () => Configuration): ModuleWithProviders<ApiModule> {
        return {
            ngModule: ApiModule,
            providers: [ { provide: Configuration, useFactory: configurationFactory } ]
        };
    }

    constructor( @Optional() @SkipSelf() parentModule: ApiModule,
                 @Optional() http: HttpClient) {
        if (parentModule) {
            throw new Error('ApiModule is already loaded. Import in your base AppModule only.');
        }
        if (!http) {
            throw new Error('You need to import the HttpClientModule in your AppModule! \n' +
            'See also https://github.com/angular/angular/issues/20575');
        }
    }
}
