import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { BookingsModule } from './bookings/bookings.module';
import { CalendarModule } from './calendar/calendar.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    BookingsModule,
    CalendarModule,
  ],
})
export class AppModule {}

