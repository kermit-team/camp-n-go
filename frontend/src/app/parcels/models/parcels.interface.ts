export interface PassedDate {
  startDate: string;
  endDate: string;
}

export interface PassedData extends PassedDate {
  childrenNumber: number;
  adultNumber: number;
}

export interface ParcelListItem {
  position: string;
  max_number_of_people: number;
  width: string;
  length: string;
  water_connection: boolean;
  electricity_connection: boolean;
  is_shaded: boolean;
  grey_water_discharge: boolean;
  description: string;
  camping_section: CampingSection;
}

export interface CampingSection {
  name: string;
  base_price: string;
  price_per_adult: string;
  price_per_child: string;
}

export interface ReserveParcel {
  sectionName: string;
  position: string;
  dateFrom: Date;
  dateTo: Date;
  childrenNumber: number;
  adultNumber: number;
}

export type Parcel = ParcelListItem;

export interface ParcelSearchFilters {
  date_from: string;
  date_to: string;
  number_of_adults: number;
  number_of_children: number;
}

export interface ReserveCampingRequest {
  sectionName: string;
  position: string;
}
