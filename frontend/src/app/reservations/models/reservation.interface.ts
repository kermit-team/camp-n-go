import { Car } from '../../auth/models/auth.interface';

export interface ReservationListItem {
  date_from: string;
  date_to: string;
  id: number;
  camping_plot: ReservationCampingPlot;
  payment: ReservationPayment;
  metadata: ReservationMetadata;
}

export interface ReservationCampingPlot {
  id: number;
  position: string;
  max_number_of_people: number;
  width: string;
  length: string;
  water_connection: boolean;
  electricity_connection: boolean;
  is_shaded: boolean;
  grey_water_discharge: boolean;
  description: string;
  camping_section: ReservationCampingSection;
}

export interface ReservationCampingSection {
  id: number;
  name: string;
  base_price: string;
  price_per_adult: string;
  price_per_child: string;
}

export interface ReservationPayment {
  id: number;
  status: number;
  price: string;
}

export interface ReservationMetadata {
  is_cancellable: boolean;
  is_car_modifiable: boolean;
}

export interface ReservationDetails {
  id: number;
  date_from: string;
  date_to: string;
  number_of_adults: number;
  number_of_children: number;
  comments: string;
  user: {
    identifier: string;
    email: string;
    profile: {
      first_name: string;
      last_name: string;
      phone_number: string;
      avatar: string;
      id_card: string;
    };
    cars: Array<Car>;
    groups: Array<UserGroup>;
    is_superuser: true;
    is_active: true;
  };
  car: Car;
  camping_plot: ReservationCampingPlot;
  payment: ReservationPayment;
  metadata: ReservationMetadata;
}

export interface UserGroup {
  id: number;
  name: string;
}

export interface ReservationChangeCar {
  carId: number;
  reservationId: number;
}
