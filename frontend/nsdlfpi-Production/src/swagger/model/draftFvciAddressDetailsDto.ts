/**
 * NSDL API
 * No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)
 *
 * OpenAPI spec version: v1
 * 
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 */

export interface DraftFvciAddressDetailsDto { 
    id?: number;
    fvciApplicationId?: string;
    flatBlockNo?: string;
    buildingPremisesVillageName?: string;
    roadStreetLaneName?: string;
    areaLocalitySubdivision?: string;
    townCityDistrict?: string;
    zipCode?: string;
    state?: string;
    countryCode?: string;
    typeOfAddress?: string;
    createdAt?: Date;
    updatedAt?: Date;
}