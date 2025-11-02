import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';

import { BookingsService, CreateBookingDto } from './bookings.service';

@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookings: BookingsService) {}

  @Get()
  list() {
    return this.bookings.list();
  }

  @Post()
  async create(@Body() dto: CreateBookingDto) {
    // 1) Persist booking (skipped: use in-memory for MVP)
    // 2) Create GCal event + Meet link via CalendarService
    const { meetUrl, gcalEventId } = await this.bookings.createAndAttachCalendar(dto);
    return { status: 'CONFIRMED', meetUrl, gcalEventId };
  }

  @Delete(':id')
  async cancel(@Param('id') id: string) {
    await this.bookings.cancel(id);
    return { ok: true };
  }
}

