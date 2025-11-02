import { Injectable } from '@nestjs/common';
import { v4 as uuid } from 'uuid';

import { CalendarService } from '../calendar/calendar.service';

export interface CreateBookingDto {
  title: string;
  start: string; // ISO
  end: string; // ISO
  attendees?: string[];
  locationName?: string;
}

@Injectable()
export class BookingsService {
  private db = new Map<string, any>();

  constructor(private readonly calendar: CalendarService) {}

  list() {
    return Array.from(this.db.values());
  }

  async createAndAttachCalendar(dto: CreateBookingDto) {
    const id = uuid();
    const event = await this.calendar.createEvent({
      summary: dto.title || 'Booking',
      start: dto.start,
      end: dto.end,
      attendees: dto.attendees ?? [],
      location: dto.locationName,
    });

    const record = {
      id,
      ...dto,
      status: 'CONFIRMED',
      gcalEventId: event.eventId,
      meetUrl: event.meetUrl,
    };
    this.db.set(id, record);
    return { gcalEventId: event.eventId, meetUrl: event.meetUrl };
  }

  async cancel(id: string) {
    const rec = this.db.get(id);
    if (!rec) {
      return;
    }
    await this.calendar.deleteEvent(rec.gcalEventId);
    this.db.delete(id);
  }
}

