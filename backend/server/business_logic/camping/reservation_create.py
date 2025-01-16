from datetime import date
from typing import Optional

from server.apps.account.models import Account
from server.apps.camping.exceptions.reservation import (
    AdultMissingForReservationError,
    CampingPlotNotAvailableForReservationError,
    CarNotBelongsToAccountError,
    IdCardMissingForReservationError,
    TooManyPeopleForReservationError,
)
from server.apps.camping.models import CampingPlot, Reservation
from server.apps.car.models import Car
from server.apps.common.exceptions.common import DateInThePastError, InvalidDateValuesError
from server.business_logic.abstract import AbstractBL
from server.business_logic.mailing.camping import ReservationCreateMail
from server.datastore.commands.camping.reservation import ReservationCommand
from server.datastore.queries.camping import CampingPlotQuery
from server.datastore.queries.car import CarQuery


class ReservationCreateBL(AbstractBL):

    @classmethod
    def process(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        user: Account,
        car: Car,
        camping_plot: CampingPlot,
        comments: Optional[str] = None,
    ) -> Reservation:
        cls._validate_reservation_date(date_from=date_from, date_to=date_to)
        cls._validate_required_personal_data(user=user, car=car)
        cls._validate_number_of_people(
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            camping_plot=camping_plot,
        )
        cls._validate_camping_plot_availability(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            camping_plot=camping_plot,
        )

        reservation = ReservationCommand.create(
            date_from=date_from,
            date_to=date_to,
            number_of_adults=number_of_adults,
            number_of_children=number_of_children,
            user=user,
            car=car,
            camping_plot=camping_plot,
            comments=comments,
        )
        ReservationCreateMail.send(reservation=reservation)

        return reservation

    @classmethod
    def _validate_reservation_date(cls, date_from: date, date_to: date) -> None:
        if date_from >= date_to:
            raise InvalidDateValuesError(date_from=date_from, date_to=date_to)

        if date_from <= date.today():
            raise DateInThePastError(given_date=date_from)

    @classmethod
    def _validate_number_of_people(
        cls,
        number_of_adults: int,
        number_of_children: int,
        camping_plot: CampingPlot,
    ) -> None:
        if number_of_adults == 0:
            raise AdultMissingForReservationError()

        number_of_people = number_of_adults + number_of_children
        if number_of_people > camping_plot.max_number_of_people:
            raise TooManyPeopleForReservationError(
                camping_plot_section_name=camping_plot.camping_section.name,
                camping_plot_position=camping_plot.position,
                max_number_of_people=camping_plot.max_number_of_people,
                number_of_people=number_of_people,
            )

    @classmethod
    def _validate_required_personal_data(cls, user: Account, car: Car) -> None:
        if not user.profile.id_card:
            raise IdCardMissingForReservationError()

        if not CarQuery.car_belongs_to_user(car=car, user=user):
            raise CarNotBelongsToAccountError(
                registration_plate=car.registration_plate,
                account_identifier=user.identifier,
            )

    @classmethod
    def _validate_camping_plot_availability(
        cls,
        date_from: date,
        date_to: date,
        number_of_adults: int,
        number_of_children: int,
        camping_plot: CampingPlot,
    ) -> None:
        camping_plot_queryset = CampingPlot.objects.filter(id=camping_plot.id)
        number_of_people = number_of_adults + number_of_children

        camping_plot_available = CampingPlotQuery.get_available(
            number_of_people=number_of_people,
            date_from=date_from,
            date_to=date_to,
            queryset=camping_plot_queryset,
        )
        if not camping_plot_available.exists():
            raise CampingPlotNotAvailableForReservationError(
                camping_plot_section_name=camping_plot.camping_section.name,
                camping_plot_position=camping_plot.position,
                date_from=date_from,
                date_to=date_to,
                number_of_people=number_of_people,
            )
