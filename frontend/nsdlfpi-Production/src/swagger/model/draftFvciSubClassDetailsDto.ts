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
import { DraftFvciSubClassBenificialOwnerDetailsDto } from './draftFvciSubClassBenificialOwnerDetailsDto';

export interface DraftFvciSubClassDetailsDto { 
    id?: number;
    fvciApplicationId?: string;
    name?: string;
    createdAt?: Date;
    updatedAt?: Date;
    subClassBenificialOwnerDetails?: Array<DraftFvciSubClassBenificialOwnerDetailsDto>;
}