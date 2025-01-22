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
  id: number;
  water_connection: boolean;
  electricity_connection: boolean;
  is_shaded: boolean;
  grey_water_discharge: boolean;
  description: string;
  camping_section: CampingSection;
  metadata: ParcelListItemMetadata;
}

export interface ParcelListItemMetadata {
  adults_price: number;
  base_price: number;
  children_price: number;
  overall_price: number;
}

export interface CampingSection {
  name: string;
  base_price: string;
  price_per_adult: string;
  price_per_child: string;
  id: number;
}

export interface ReserveParcel {
  id: number;
  dateFrom: Date;
  dateTo: Date;
  childrenNumber: number;
  adultNumber: number;
}

export type Parcel = ParcelListItem;

export type ParcelToReserve = Parcel & ParcelSearchFilters;

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

export interface CreateReservationRequest {
  date_from: string;
  date_to: string;
  number_of_adults: number;
  number_of_children: number;
  car: number;
  camping_plot: number;
  comments?: string;
}

export interface CreateReservationResponse {
  date_from: string;
  date_to: string;
  number_of_adults: number;
  number_of_children: number;
  car: number;
  camping_plot: number;
  comments: string;
  id: number;
  checkout_url: string;
}
