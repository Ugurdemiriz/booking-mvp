import { Injectable } from '@nestjs/common';
import { google } from 'googleapis';
import { v4 as uuid } from 'uuid';

interface CreateEventInput {
  summary: string;
  start: string;
  end: string;
  attendees: string[];
  location?: string;
}

@Injectable()
export class CalendarService {
  private calendar = google.calendar('v3');

  private auth() {
    const client = new google.auth.OAuth2(
      process.env.GOOGLE_CLIENT_ID,
      process.env.GOOGLE_CLIENT_SECRET,
      process.env.GOOGLE_REDIRECT_URI,
    );
    client.setCredentials({ refresh_token: process.env.GOOGLE_REFRESH_TOKEN });
    return client;
  }

  async createEvent(input: CreateEventInput) {
    const auth = this.auth();
    const requestId = uuid();

    const res = await this.calendar.events.insert({
      auth,
      calendarId: 'primary',
      conferenceDataVersion: 1,
      requestBody: {
        summary: input.summary,
        location: input.location,
        start: { dateTime: input.start },
        end: { dateTime: input.end },
        attendees: input.attendees.map((email) => ({ email })),
        conferenceData: {
          createRequest: {
            requestId,
            conferenceSolutionKey: { type: 'hangoutsMeet' },
          },
        },
      },
    });

    const event = res.data;
    const meetUrl =
      event.hangoutLink ||
      event.conferenceData?.entryPoints?.find((p) => p.entryPointType === 'video')?.uri;
    return { eventId: event.id!, meetUrl };
  }

  async deleteEvent(eventId: string) {
    const auth = this.auth();
    await this.calendar.events.delete({
      auth,
      calendarId: 'primary',
      eventId,
    });
  }
}

