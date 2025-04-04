export const data = [
  {
    id: 'a)',
    name: 'Date of Incorporation/ Establishment/ Formation',
  },
  {
    id: 'b)',
    name: 'Date of Commencement of Business',
  },
];

export const taxData = [
  {
    id: 'b)',
    trcNo: '',
    country: '',
  },
];

export const tableData = [
  {
    id: 'a)',
    name: 'Place',
    placeHolder: 'Enter Place',
    type: 'text',
  },
  {
    id: 'b)',
    name: 'Country',
    placeHolder: 'Enter Country',
    type: 'dropdown',
    dropdownType: 'country',
  },
  {
    id: 'c)',
    name: 'ISD Country Code',
    placeHolder: 'Enter ISD Code',
    type: 'dropdown',
    dropdownType: 'countryCode',
  },
];

export const contactData = [
  {
    id: 'a)',
  },
];

export const detailsData = [
  {
    id: '1',
    text: 'Name & Address of the Beneficial Owner *',
    placeHolder: 'Enter Name & Address',
    type: 'text',
    isRequire: true,
  },
  {
    id: '2',
    text: 'Date of Birth *',
    placeHolder: 'Select Date of Birth *',
    type: 'date',
    isRequire: true,
  },
  {
    id: '3',
    text: 'Tax Residency Jurisdiction *',
    placeHolder: 'Enter Tax Residency Jurisdiction',
    type: 'text',
    options: ['India', 'USA', 'UK', 'Australia'],
    isRequire: true,
  },
  {
    id: '4',
    text: 'Nationality *',
    placeHolder: 'Enter Nationality',
    type: 'text',
    options: ['Indian', 'American', 'British', 'Australian'],
    isRequire: true,
  },
  {
    id: '5',
    text: 'Whether acting alone or together, or through one or more natural person as group with their name & address',
    placeHolder: 'Enter Details',
    type: 'text',
    isRequire: false,
  },
  {
    id: '6',
    text: 'BO Group Percentage Shareholding / Capital / profit ownership in the FPIs',
    placeHolder: 'Enter Details',
    type: 'text',
    isRequire: false,
  },
  {
    id: '7',
    text: 'Tax Residency Number/Social Security Number/Passport Number of BO/any other Government issued identity document number (example Driving Licence) [Please provide any]',
    placeHolder: 'Enter Details',
    type: 'text',
    isRequire: false,
  },
];

export const docData = [
  {
    id: 'a)',
    name: 'Proof of Identity (POI)',
    placeHolder: 'Proof of Identity',
    type: 'POI',
  },
  {
    id: 'b)',
    name: 'Proof of Address (POA)',
    placeHolder: 'Proof of Address',
    type: 'POA',
  },
];

export const designationData = [
  {
    id: 'a)',
    name: 'Details of Designated Depository Participant',
  },
  {
    id: 'b)',
    name: 'Details of Custodian',
  },
  {
    id: 'c)',
    name: 'Details of Depository Participant',
  },
];

export const regulationData = [
  {
    id: 'a)',
    name: 'Name',
    placeholder: 'Enter Name',
    type: 'dropdown',
  },
  {
    id: 'b)',
    name: 'Country',
    placeholder: 'Select Country',
    type: 'text',
  },
  {
    id: 'c)',
    name: 'Website',
    placeholder: 'Enter Name',
    type: 'text',
  },
  {
    id: 'd)',
    name: 'Registration Number/Code with regulator, if any',
    placeholder: 'Enter Number/Code',
    type: 'text',
  },
  {
    id: 'e)',
    name: 'Category / Capacity in which the applicant is Regulated',
    placeholder: 'Enter Category/Capacity',
    type: 'text',
  },
];

export const announcementData = [
  { date: 'Aug 05, 2016 | 03.00 pm', name: 'Updated FAQs released by SEBI on the FPI Regime (Dt: November 07, 2014)' },
  {
    date: '07 Oct | 03:49 PM',
    name: 'Updated FAQs released by SEBI on the FPI Regime (Dt: October 07, 2014)',
  },
  {
    date: '08 Aug | 09:24 PM',
    name: 'Updated Frequently Asked Questions - July 25 2014 SIGNED (Dt: August 08, 2014)',
  },
  {
    date: '25 Jul | 08:55 AM',
    name: 'Frequently Asked Question(FAQs) on FPI Regime (Dt: July 25, 2014)',
  },
  {
    date: '26 May | 08:55 AM',
    name: 'Frequently Asked Questions on KYC requirements for Eligible Foreign Investors (EFIs) / Foreign Portfolio Investors (FPIs). (Dt: May 26, 2014)',
  },
  {
    date: '02 May | 08:55 AM',
    name: 'Frequently Asked Questions (FAQs) in respect of SEBI (Foreign Portfolio Investors) Regulations, 2014 (Dt: May 2, 2014)',
  },
];

export const circularData = [
  { date: '23 APR | 08:10 PM', name: 'Revision of limits relating to requirement of underlying exposure for currency derivatives contracts' },
  {
    date: '17 APR | 03:59 PM',
    name: 'FPI investments - Re-investment facility',
  },
  {
    date: '15 APR | 07:37 PM',
    name: 'Guidelines for reporting of investment related to Coupon on Government securities',
  },
  {
    date: '12 FEB | 05:38 PM',
    name: 'Change in investment conditions for FPI investments in Government Debt Securities',
  },
  {
    date: '04 Feb | 07:45 PM',
    name: 'Change in investment conditions -restrictions for FPI investments in Corporate Debt securities (Dt: February 04, 2015)'
  },
  {
    date: '10 Oct | 04:14 PM',
    name: 'Clarification on Government Debt Investment Limits (Dt: October 10, 2014)',
  },
  {
    date: '16 Sep | 05:30 PM',
    name: 'Investments by FPIs-FIIs-QFIs in Commercial Papers (Dt: September 16, 2014)',
  },
  {
    date: '07 Jul | 05:08 PM',
    name: 'Participation of FPIs in the Currency Derivatives segment and Position limits for currency derivatives contracts (Dt: July 07, 2014)',
  },
  {
    date: '25 Jun | 08:14 PM',
    name: 'Investments by FPIs in Non-Convertible_Redeemable preference shares or debentures of Indian companies (Dt: June 25, 2014)',
  },
  {
    date: '17 Jun | 08:04 PM',
    name: 'Know Your Client (KYC) requirements for Foreign Portfolio Investors (FPIs) (Dt: June 17, 2014)',
  },
  {
    date: '21 May | 08:55 AM',
    name: 'Risk management framework for Foreign Portfolio Investors (FPI) under the SEBI (Foreign Portfolio Investors) Regulations, 2014. (Dt: May 21, 2014)',
  },
  {
    date: '07 May | 08:55 AM',
    name: 'Infrastructure facilities and submission of periodic reports (Dt: May 7, 2014)',
  },
  {
    date: '01 Apr | 08:55 AM',
    name: 'Commencement of Foreign Portfolio Investor (FPI) regime. (Dt: April 1, 2014)',
  },
  {
    date: '27 Jan | 08:55 AM',
    name: 'Incorporation of Types/Sub-types in respect of Foreign Portfolio Investors (FPI) ',
  },
  {
    date: '25 Jun | 08:55 AM',
    name: '2014-0005-Policy-DDP-Investment by FPI in Non-Convertible / Redeemable preference shares or debentures of Indian companies',
  },
  {
    date: '17 Jun | 08:55 AM',
    name: '2014-0005-Policy-DDP-SEBI Circular dated June 17,2014',
  },
];

export const signatoryData = [
  {
    id: 'name',
    label: '1',
    text: 'Name',
    type: 'text',
    placeholder: 'Enter Full Name',
  },
  {
    id: 'relationWithApplicant',
    label: '2',
    text: 'Relationship with Applicant (e.g., promoters, directors, signatory, etc.)',
    type: 'text',
    placeholder: 'Enter Relationship With Applicant',
  },
  {
    id: 'pan',
    label: '3',
    text: 'PAN (if applicable)',
    type: 'text',
    placeholder: 'Enter PAN',
  },
  {
    id: 'nationatlity',
    label: '4',
    text: 'Nationality / Country of Residence',
    type: 'dropdown',
    placeholder: 'Select Nationality',
  },
  {
    id: 'dateOfBirth',
    label: '5',
    text: 'Date of Birth (DD/MM/YYYY)',
    type: 'date',
    placeholder: 'Select Date Of Birth',
  },
  {
    id: 'residentialAddress',
    label: '6',
    text: 'Residential/Registered Address',
    type: 'text',
    placeholder: 'Enter Address',
  },
  {
    id: 'identityDocNumber',
    label: '7',
    text: 'Government Issued Identity Document Number (e.g., Driving License)',
    type: 'text',
    placeholder: 'Enter Document Number',
  },
];

export const segregatedPortfolio = [
  {
    id: 'nameAddressOfBo',
    label: '1',
    text: 'Name & Address of the Beneficial Owner (Natural Person)',
    placeholder: 'Enter Name & Address',
    type: 'text',
  },
  {
    id: 'dateOfBirthOfBo',
    label: '2',
    text: 'Date of Birth',
    placeholder: 'Select Date of Birth',
    type: 'date',
  },
  {
    id: 'taxResidencyJuridiction',
    label: '3',
    text: 'Tax Residency Jurisdiction',
    placeholder: 'Enter Tax Residency Jurisdiction',
    type: 'dropdown',
  },
  {
    id: 'nationality',
    label: '4',
    text: 'Nationality',
    placeholder: 'Enter Nationality',
    type: 'dropdown',
  },
  {
    id: 'actingAloneOrMoreNaturalPerson',
    label:'5',
    text: 'Whether acting alone or together, or through one or more natural person as group with their name & address',
    placeholder: 'Enter Details',
    type: 'text',
  },
  {
    id: 'boGroupPercentageShareHolding',
    label: '6',
    text: 'Beneficial Owner (BO) Group Percentage Shareholding / Capital / profit ownership in the FVCIs',
    placeholder: 'Enter Details',
    type: 'text',
  },
  {
    id: 'identityDocument',
    label: '7',
    text: 'Tax Residency Number/Social Security Number/Passport Number of BO/any other Government issued identity document number (example Driving Licence) [Please provide any]',
    placeholder: 'Enter Details',
    type: 'text',
  },
];

export interface City {
  name: string;
  code: string;
}

export interface TaxRow {
  id: string;
  trcNo: string;
  country: string;
}

export interface UploadEvent {
  originalEvent: Event;
  files: File[];
}

export interface Country {
  name: string;
  code: string;
}

export interface FPI {
  id: number;
  registrationNo: string;
  name: string;
  category: 'Category 1' | 'Category 2' | 'Category 3';
  validUpto: string;
  country: Country;
  status: 'registered' | 'invalid' | 'expired';
}

export interface Income {
  name: string;
  code: number;
  disabled: boolean
}

export const fpiData: FPI[] = [
  {
    id: 1,
    registrationNo: 'IN0001234567',
    name: 'BlackRock Investment Management',
    category: 'Category 1',
    validUpto: '2025-12-31',
    country: {
      name: 'United States',
      code: 'us',
    },
    status: 'registered',
  },
  {
    id: 2,
    registrationNo: 'IN0002345678',
    name: 'Fidelity International',
    category: 'Category 2',
    validUpto: '2024-06-30',
    country: {
      name: 'United Kingdom',
      code: 'gb',
    },
    status: 'registered',
  },
  {
    id: 3,
    registrationNo: 'IN0003456789',
    name: 'Nomura Asset Management',
    category: 'Category 3',
    validUpto: '2023-12-31',
    country: {
      name: 'Japan',
      code: 'jp',
    },
    status: 'expired',
  },
  {
    id: 4,
    registrationNo: 'IN0004567890',
    name: 'UBS Asset Management',
    category: 'Category 1',
    validUpto: '2024-03-15',
    country: {
      name: 'Switzerland',
      code: 'ch',
    },
    status: 'invalid',
  },
  {
    id: 5,
    registrationNo: 'IN0005678901',
    name: 'Deutsche Bank Investment',
    category: 'Category 2',
    validUpto: '2025-09-30',
    country: {
      name: 'Germany',
      code: 'de',
    },
    status: 'registered',
  },
  {
    id: 6,
    registrationNo: 'IN0005678902',
    name: 'HSBC Global Finance',
    category: 'Category 1',
    validUpto: '2026-03-15',
    country: {
      name: 'United Kingdom',
      code: 'gb',
    },
    status: 'registered',
  },
  {
    id: 7,
    registrationNo: 'IN0005678903',
    name: 'Citibank Capital Markets',
    category: 'Category 3',
    validUpto: '2027-07-20',
    country: {
      name: 'United States',
      code: 'us',
    },
    status: 'invalid',
  },
  {
    id: 8,
    registrationNo: 'IN0005678904',
    name: 'Mizuho Securities',
    category: 'Category 2',
    validUpto: '2025-12-10',
    country: {
      name: 'Japan',
      code: 'jp',
    },
    status: 'registered',
  },
  {
    id: 9,
    registrationNo: 'IN0005678905',
    name: 'BNP Paribas Asset Management',
    category: 'Category 1',
    validUpto: '2026-06-30',
    country: {
      name: 'France',
      code: 'fr',
    },
    status: 'expired',
  },
  {
    id: 10,
    registrationNo: 'IN0005678906',
    name: 'Standard Chartered Investments',
    category: 'Category 3',
    validUpto: '2028-02-05',
    country: {
      name: 'Singapore',
      code: 'sg',
    },
    status: 'registered',
  },
];

export const priorAssociationDetailsData = [
  {
    id: '1',
    text: 'Name of the entity *',
    placeHolder: 'Name of the entity',
    type: 'text',
    isRequired: true,
  },
  {
    id: '2',
    text: 'Registered/ associated as *',
    placeHolder: 'Registered/ associated as *',
    type: 'text',
    isRequired: true,
  },
  {
    id: '3',
    text: 'SEBI registration number',
    placeHolder: 'SEBI registration number',
    type: 'text',
    isRequired: false,
  },
  {
    id: '4',
    text: 'Period of registration *',
    placeHolder: 'Period of registration',
    type: 'text',
    isRequired: true,
  },
];