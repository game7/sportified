namespace App {
  export type FlashType = "notice" | "error" | "info" | "warning" | "success";

  export type Flash = Partial<Record<FlashType, string>>;

  export interface User {}

  export interface SharedProps {
    current_user: User;
    flash: Flash;
    [key: string]: unknown;
  }
}

// add `& (string | number)` to the keyof ObjectType
declare type NestedKeyOf<ObjectType extends object> = {
  [Key in keyof ObjectType & (string | number)]: ObjectType[Key] extends object
    ? `${Key}` | `${Key}.${NestedKeyOf<ObjectType[Key]>}`
    : `${Key}`;
}[keyof ObjectType & (string | number)];

declare type WithOptional<Type, Key extends keyof Type> = Type & {
  [Property in Key]-?: Type[Property];
};

namespace ActiveStorage {
  export interface Blob {
    attachable_sgid: string;
    byte_size: number;
    checksum: string;
    content_type: string;
    created_at: string;
    filename: string;
    id: number;
    key: string;
    metadata: any;
    service_name: string;
    signed_id: string;
    url: string;
    "image?": boolean;
  }
}

namespace App {
  export interface Tenant {
    id: integer;
    address: string;
    description: string;
    google_fonts: string;
    host: string;
    name: string;
    slug: string;
    stripe_access_token: string;
    stripe_private_key: string;
    stripe_public_api_key: string;
    stripe_public_key: string;
    style: string;
    theme: string;
    time_zone: string;
    created_at: string;
    updated_at: string;
    analytics_id: string;
    facebook_id: string;
    foursquare_id: string;
    google_plus_id: string;
    instagram_id: string;
    stripe_account_id: string;
    stripe_client_id: string;
    twitter_id: string;
  }
  export interface Event {
    id: number;
    visit_id: number;
    user_id: number;
    name: string;
    properties: {
      backtrace?: string[];
      format: string;
      host: string;
      message?: string;
      params: Record<string, string>;
      path: string;
      url: string;
    };
    time: string;
    tenant_id: number;
  }

  export interface Exception {
    id: number;
    visit_id: number;
    user_id: number;
    name: string;
    properties: {
      url: string;
      host: string;
      path: string;
      format: string;
      params: Record<string, string>;
      message: string;
      backtrace: string[];
      exception: string;
    };
    time: string;
    tenant_id: number;
  }
  export interface Visit {
    id: number;
    visit_token: string;
    visitor_token: string;
    user_id: number;
    ip: string;
    user_agent: string;
    referrer: string;
    referring_domain: string;
    landing_page: string;
    browser: string;
    os: string;
    device_type: string;
    country: string;
    region: string;
    city: string;
    latitude: string;
    longitude: string;
    utm_source: string;
    utm_medium: string;
    utm_term: string;
    utm_content: string;
    utm_campaign: string;
    app_version: string;
    os_version: string;
    platform: string;
    started_at: string;
    tenant_id: number;
    tenant?: Tenant;
  }
  export interface Program {
    id: number;
    tenant_id: number;
    name: string;
    description: string;
    created_at: string;
    updated_at: string;
    slug: string;
  }
  export interface Location {
    id: number;
    tenant_id: number;
    name: string;
    short_name: string;
    created_at: string;
    updated_at: string;
    deleted_at: string;
  }
  export interface Event {
    id: number;
    tenant_id: number;
    division_id: number;
    season_id: number;
    location_id: number;
    starts_on: string;
    ends_on: string;
    duration: number;
    all_day: boolean;
    summary: string;
    description: string;
    created_at: string;
    updated_at: string;
    home_team_id: number;
    away_team_id: number;
    statsheet_id: number;
    statsheet_type: string;
    home_team_score: number;
    away_team_score: number;
    home_team_name: string;
    away_team_name: string;
    home_team_custom_name: boolean;
    away_team_custom_name: boolean;
    text_before: string;
    text_after: string;
    result: string;
    completion: string;
    exclude_from_team_records: boolean;
    playing_surface_id: number;
    home_team_locker_room_id: null;
    away_team_locker_room_id: null;
    program_id: 49;
    page_id: null;
    private: false;
    tag_list: string[];
    location?: Location;
    program?: Program;
    tags?: Tag[];
    type: string;
  }
  export interface Tag {
    id: number;
    name: string;
    taggings_count: number;
    color: string;
  }
  namespace General {
    export interface Event {
      all_day: boolean;
      away_team_custom_name: string;
      away_team_id: number;
      away_team_locker_room_id: number;
      away_team_name: string;
      away_team_score: number;
      completion: string;
      created_at: string;
      description: number;
      division_id: number;
      duration: number;
      ends_on: string;
      exclude_from_team_records: boolean;
      home_team_custom_name: string;
      home_team_id: number;
      home_team_locker_room_id: number;
      home_team_name: string;
      home_team_score: number;
      id: number;
      location_id: number;
      page_id: number;
      playing_surface_id: number;
      private: boolean;
      program_id: number;
      result: string;
      season_id: number;
      starts_on: string;
      statsheet_id: number;
      statsheet_type: string;
      summary: string;
      tag_list: string[];
      tenant_id: number;
      text_after: string;
      text_before: string;
      updated_at: string;
      recurrence_id: number;
      recurrence?: Recurrence;
    }
  }
  interface Recurrence {
    created_at: string;
    ending: string;
    ends_on: string;
    friday: boolean;
    id: number;
    monday: boolean;
    occurrence_count: number;
    saturday: boolean;
    sunday: boolean;
    thursday: boolean;
    tuesday: boolean;
    updated_at: boolean;
    wednesday: boolean;
  }
  interface Location {
    color: string;
    created_at: string;
    deleted_at: string;
    id: number;
    name: string;
    short_name: string;
    tenant_id: number;
    updated_at: string;
  }

  interface Tag {
    color: string;
    id: number;
    name: string;
    taggings_count: number;
  }

  interface Team {
    accent_color: string;
    allowed: number;
    club_id: number;
    created_at: string;
    crop_h: number;
    crop_w: number;
    crop_x: number;
    crop_y: number;
    current_run: number;
    custom_colors: any;
    division_id: number;
    forfeit_losses: number;
    forfeit_wins: number;
    games_played: number;
    id: number;
    last_result: string;
    logo: any;
    longest_loss_streak: number;
    longest_win_streak: number;
    losses: number;
    main_colors: string[];
    margin: number;
    name: string;
    overtime_losses: number;
    overtime_wins: number;
    percent: number;
    points: number;
    pool: string;
    primary_color: string;
    scored: number;
    season_id: number;
    secondary_color: string;
    seed: null;
    shootout_losses: number;
    shootout_wins: number;
    short_name: string;
    show_in_standings: true;
    slug: string;
    tenant_id: number;
    ties: number;
    updated_at: string;
    wins: number;
  }

  interface Post {
    body: string;
    created_at: string;
    id: number;
    image: {
      url: string;
      thumb: {
        url: string;
      };
    };
    link_url: string[];
    photo: any;
    summary: string[];
    tag_list: string[];
    tenant_id: number;
    title: string;
    updated_at: string;
  }
}
