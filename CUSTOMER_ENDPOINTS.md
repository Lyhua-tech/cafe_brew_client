# Customer API Endpoints Documentation

This document lists all API endpoints intended for customer use in the Corner Coffee application. Admin-only endpoints are excluded from this list.

**Base URL:** `/api`

---

## 1. Authentication & Registration

Endpoints for user sign-up, login, and session management.

| Method | Endpoint                  | Description                                   | Auth Required |
| ------ | ------------------------- | --------------------------------------------- | ------------- |
| POST   | `/auth/register/initiate` | Initiate registration by sending OTP to email | No            |
| POST   | `/auth/register/verify`   | Complete registration with OTP verification   | No            |
| POST   | `/auth/login`             | Login with email and password                 | No            |
| POST   | `/auth/forgot-password`   | Initiate password reset (sends OTP)           | No            |
| POST   | `/auth/reset-password`    | Reset password with OTP verification          | No            |
| POST   | `/auth/verify-otp`        | Verify OTP code                               | No            |
| POST   | `/auth/resend-otp`        | Resend OTP code                               | No            |
| GET    | `/auth/me`                | Get current authenticated user profile        | Yes           |
| POST   | `/auth/refresh-token`     | Refresh access token                          | No            |
| POST   | `/auth/logout`            | Logout and revoke refresh token               | No            |

### Payloads

#### `POST /auth/register/initiate`

| Field    | Type   | Required | Constraints                     |
| -------- | ------ | -------- | ------------------------------- |
| fullName | string | ✅       | Min 1 char, trimmed             |
| email    | string | ✅       | Valid email, trimmed, lowercase |
| password | string | ✅       | Min 6 characters                |

#### `POST /auth/register/verify`

| Field    | Type   | Required | Constraints                     |
| -------- | ------ | -------- | ------------------------------- |
| fullName | string | ✅       | Min 1 char, trimmed             |
| email    | string | ✅       | Valid email, trimmed, lowercase |
| password | string | ✅       | Min 6 characters                |
| otpCode  | string | ✅       | Exactly 6 digits                |

#### `POST /auth/login`

| Field    | Type   | Required | Constraints                     |
| -------- | ------ | -------- | ------------------------------- |
| email    | string | ✅       | Valid email, trimmed, lowercase |
| password | string | ✅       | Min 6 characters                |

#### `POST /auth/forgot-password`

| Field | Type   | Required | Constraints                     |
| ----- | ------ | -------- | ------------------------------- |
| email | string | ✅       | Valid email, trimmed, lowercase |

#### `POST /auth/reset-password`

| Field       | Type   | Required | Constraints                     |
| ----------- | ------ | -------- | ------------------------------- |
| email       | string | ✅       | Valid email, trimmed, lowercase |
| otpCode     | string | ✅       | Exactly 6 digits                |
| newPassword | string | ✅       | Min 6 characters                |

#### `POST /auth/verify-otp`

| Field            | Type   | Required | Constraints                            |
| ---------------- | ------ | -------- | -------------------------------------- |
| email            | string | ✅       | Valid email, trimmed, lowercase        |
| otpCode          | string | ✅       | Exactly 6 digits                       |
| verificationType | string | ❌       | Enum: `registration`, `password_reset` |

#### `POST /auth/resend-otp`

| Field            | Type   | Required | Constraints                            |
| ---------------- | ------ | -------- | -------------------------------------- |
| email            | string | ✅       | Valid email, trimmed, lowercase        |
| verificationType | string | ✅       | Enum: `registration`, `password_reset` |

#### `POST /auth/refresh-token`

| Field        | Type   | Required | Constraints |
| ------------ | ------ | -------- | ----------- |
| refreshToken | string | ✅       | Min 1 char  |

#### `POST /auth/logout`

| Field        | Type   | Required | Constraints |
| ------------ | ------ | -------- | ----------- |
| refreshToken | string | ✅       | Min 1 char  |

### Responses

> All responses are wrapped in: `{ "statusCode": number, "data": ..., "message": string, "success": boolean }`

#### `POST /auth/register/initiate` — `200`

```json
{
  "message": "OTP sent to email",
  "email": "user@example.com",
  "otpExpiresAt": "2026-03-04T12:45:00.000Z"
}
```

#### `POST /auth/register/verify` — `201`

```json
{
  "message": "Registration completed successfully"
}
```

#### `POST /auth/login` — `200`

```json
{
  "user": {
    "id": "664abc...",
    "fullName": "John Doe",
    "email": "john@example.com",
    "createdAt": "2026-01-01T00:00:00.000Z",
    "updatedAt": "2026-03-01T00:00:00.000Z"
  },
  "accessToken": "eyJhbGciOi...",
  "refreshToken": "eyJhbGciOi..."
}
```

#### `POST /auth/forgot-password` — `200`

```json
{
  "message": "Password reset OTP sent",
  "otpExpiresAt": "2026-03-04T12:45:00.000Z"
}
```

#### `POST /auth/reset-password` — `200`

```json
{ "message": "Password reset successfully" }
```

#### `POST /auth/verify-otp` — `200`

```json
{ "message": "OTP verified successfully" }
```

#### `POST /auth/resend-otp` — `200`

```json
{
  "message": "OTP resent successfully",
  "otpExpiresAt": "2026-03-04T12:45:00.000Z"
}
```

#### `GET /auth/me` — `200`

```json
{
  "id": "664abc...",
  "fullName": "John Doe",
  "email": "john@example.com",
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-03-01T00:00:00.000Z"
}
```

> **Note:** `GET /auth/me` returns a slim user object. For the full profile, use `GET /profile`.

#### `POST /auth/refresh-token` — `200`

```json
{
  "accessToken": "eyJhbGciOi...",
  "refreshToken": "eyJhbGciOi..."
}
```

#### `POST /auth/logout` — `200`

```json
{ "message": "User logged out successfully" }
```

---

## 2. User Profile & Addresses

Manage personal information and delivery addresses.

| Method | Endpoint                                 | Description              | Auth Required |
| ------ | ---------------------------------------- | ------------------------ | ------------- |
| GET    | `/profile`                               | Get user profile details | Yes           |
| PUT    | `/profile`                               | Update user profile      | Yes           |
| POST   | `/profile/image`                         | Upload profile image     | Yes           |
| PUT    | `/profile/password`                      | Update account password  | Yes           |
| PUT    | `/profile/settings`                      | Update user settings     | Yes           |
| GET    | `/profile/referral`                      | Get referral statistics  | Yes           |
| DELETE | `/profile`                               | Delete user account      | Yes           |
| GET    | `/users/me/addresses`                    | Get all saved addresses  | Yes           |
| POST   | `/users/me/addresses`                    | Add a new address        | Yes           |
| PATCH  | `/users/me/addresses/:addressId`         | Update an address        | Yes           |
| DELETE | `/users/me/addresses/:addressId`         | Delete an address        | Yes           |
| PATCH  | `/users/me/addresses/:addressId/default` | Set address as default   | Yes           |

### Payloads

#### `PUT /profile`

| Field       | Type   | Required | Constraints                                      |
| ----------- | ------ | -------- | ------------------------------------------------ |
| fullName    | string | ❌       | Min 1 char, max 100 chars, trimmed               |
| email       | string | ❌       | Valid email, trimmed, lowercase                  |
| phoneNumber | string | ❌       | Starts with `0`, 9-10 digits (e.g. `0123456789`) |
| dateOfBirth | date   | ❌       | ISO date string                                  |
| gender      | string | ❌       | Enum: `male`, `female`, `other`                  |
| preferences | object | ❌       | See Preferences object below                     |

**Preferences Object:**
| Field | Type | Required | Default |
|-------|------|----------|---------|
| notificationsEnabled | boolean | ❌ | `true` |
| emailNotifications | boolean | ❌ | `true` |
| smsNotifications | boolean | ❌ | `true` |
| pushNotifications | boolean | ❌ | `true` |
| language | string | ❌ | `en` (Enum: `en`, `km`) |
| currency | string | ❌ | `USD` (Enum: `USD`, `KHR`) |
| notifications | object | ❌ | `{ orderUpdates, promotions, announcements, systemNotifications }` — all boolean |

#### `POST /profile/image`

| Field    | Type   | Required | Constraints |
| -------- | ------ | -------- | ----------- |
| imageUrl | string | ✅       | Valid URL   |

#### `PUT /profile/password`

| Field           | Type   | Required | Constraints      |
| --------------- | ------ | -------- | ---------------- |
| currentPassword | string | ✅       | Min 1 char       |
| newPassword     | string | ✅       | Min 6 characters |

#### `PUT /profile/settings`

| Field                | Type    | Required | Constraints                                                                      |
| -------------------- | ------- | -------- | -------------------------------------------------------------------------------- |
| notificationsEnabled | boolean | ❌       |                                                                                  |
| emailNotifications   | boolean | ❌       |                                                                                  |
| smsNotifications     | boolean | ❌       |                                                                                  |
| pushNotifications    | boolean | ❌       |                                                                                  |
| language             | string  | ❌       | Enum: `en`, `km`                                                                 |
| currency             | string  | ❌       | Enum: `USD`, `KHR`                                                               |
| notifications        | object  | ❌       | `{ orderUpdates, promotions, announcements, systemNotifications }` — all boolean |

#### `DELETE /profile`

| Field    | Type   | Required | Constraints |
| -------- | ------ | -------- | ----------- |
| password | string | ✅       | Min 1 char  |
| reason   | string | ❌       |             |

#### `POST /users/me/addresses`

| Field                | Type   | Required | Constraints                               |
| -------------------- | ------ | -------- | ----------------------------------------- |
| label                | string | ✅       | Min 1, max 50 chars (e.g. "Home", "Work") |
| fullName             | string | ✅       | Min 1, max 100 chars                      |
| phoneNumber          | string | ✅       | Starts with `0`, 9-10 digits              |
| addressLine1         | string | ✅       | Min 1, max 200 chars                      |
| addressLine2         | string | ❌       | Max 200 chars                             |
| city                 | string | ✅       | Min 1, max 100 chars                      |
| state                | string | ✅       | Min 1, max 100 chars                      |
| postalCode           | string | ❌       | 3-10 alphanumeric chars                   |
| country              | string | ✅       | Min 1, max 100 chars                      |
| latitude             | number | ❌       | -90 to 90                                 |
| longitude            | number | ❌       | -180 to 180                               |
| deliveryInstructions | string | ❌       | Max 500 chars                             |

#### `PATCH /users/me/addresses/:addressId`

Same fields as `POST /users/me/addresses` — all fields are **optional** (partial update).

### Responses

#### `GET /profile` — `200`

```json
{
  "_id": "664abc...",
  "fullName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "0123456789",
  "profileImage": "https://res.cloudinary.com/...",
  "dateOfBirth": "1995-06-15T00:00:00.000Z",
  "gender": "male",
  "emailVerified": true,
  "phoneVerified": false,
  "role": "user",
  "loyaltyPoints": 250,
  "loyaltyTier": "silver",
  "referralCode": "REF7ABC12XY",
  "referredBy": null,
  "totalOrders": 12,
  "totalSpent": 156.5,
  "preferences": {
    "notificationsEnabled": true,
    "emailNotifications": true,
    "smsNotifications": true,
    "pushNotifications": true,
    "language": "en",
    "currency": "USD",
    "notifications": {
      "orderUpdates": true,
      "promotions": true,
      "announcements": true,
      "systemNotifications": true
    }
  },
  "status": "active",
  "lastLoginAt": "2026-03-04T10:00:00.000Z",
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-03-04T10:00:00.000Z"
}
```

#### `PUT /profile` — `200`

Returns the updated user profile object (same shape as `GET /profile`).

#### `POST /profile/image` — `200`

Returns the updated user profile object (same shape as `GET /profile`).

#### `PUT /profile/password` — `200`

```json
{ "message": "Password updated successfully" }
```

#### `PUT /profile/settings` — `200`

Returns the updated user profile object (same shape as `GET /profile`).

#### `GET /profile/referral` — `200`

````json
{
  "referralCode": "REF7ABC12XY",
  "totalReferrals": 5,
  "pointsEarned": 500
}
```

#### `DELETE /profile` — `200`

```json
{ "data": null }
````

#### `GET /users/me/addresses` — `200`

Array of address objects.

```json
[
  {
    "_id": "664abc...",
    "label": "Home",
    "fullName": "John Doe",
    "phoneNumber": "0123456789",
    "addressLine1": "123 Main St",
    "addressLine2": "Apt 4",
    "city": "Phnom Penh",
    "state": "Phnom Penh",
    "postalCode": "12000",
    "country": "Cambodia",
    "latitude": 11.556,
    "longitude": 104.928,
    "isDefault": true,
    "deliveryInstructions": "Ring doorbell"
  }
]
```

#### `POST /users/me/addresses` — `201`

Returns the newly created address object.

#### `PATCH /users/me/addresses/:addressId` — `200`

Returns the updated address object.

#### `DELETE /users/me/addresses/:addressId` — `200`

```json
{ "data": null }
```

#### `PATCH /users/me/addresses/:addressId/default` — `200`

Returns the updated address object with `isDefault: true`.

---

## 3. Stores & Locations

Browse coffee shop locations and their details.

| Method | Endpoint                    | Description                                 | Auth Required |
| ------ | --------------------------- | ------------------------------------------- | ------------- |
| GET    | `/stores`                   | Get all active stores (optional geo-search) | No            |
| GET    | `/stores/slug/:slug`        | Get store details by slug                   | No            |
| GET    | `/stores/:id`               | Get store details by ID                     | No            |
| GET    | `/stores/:id/pickup-times`  | Get available pickup slots                  | No            |
| GET    | `/stores/:storeId/gallery`  | Get store gallery images                    | No            |
| GET    | `/stores/:storeId/hours`    | Get store operating hours                   | No            |
| GET    | `/stores/:storeId/location` | Get store location details                  | No            |
| GET    | `/stores/:storeId/menu`     | Get products available at a specific store  | No            |

### Payloads

#### `GET /stores` — Query Parameters

| Field     | Type   | Required | Constraints     |
| --------- | ------ | -------- | --------------- |
| latitude  | number | ❌\*     | -90 to 90       |
| longitude | number | ❌\*     | -180 to 180     |
| radius    | number | ❌\*     | Positive number |

> \*If any one of `latitude`, `longitude`, `radius` is provided, **all three** must be provided.

#### `GET /stores/:id/pickup-times` — Query Parameters

| Field | Type   | Required | Constraints                         |
| ----- | ------ | -------- | ----------------------------------- |
| date  | string | ❌       | ISO datetime or `YYYY-MM-DD` format |

#### `GET /stores/:storeId/menu` — Query Parameters

| Field         | Type               | Required | Constraints                 |
| ------------- | ------------------ | -------- | --------------------------- |
| categoryId    | string             | ❌       | Valid MongoDB ObjectId      |
| isFeatured    | string             | ❌       | `"true"` or `"false"`       |
| isBestSelling | string             | ❌       | `"true"` or `"false"`       |
| tags          | string \| string[] | ❌       | Single tag or array of tags |
| minPrice      | number             | ❌       | ≥ 0                         |
| maxPrice      | number             | ❌       | ≥ 0                         |

### Responses

#### `GET /stores` — `200`

Paginated store list: `{ data: Store[], pagination: { page, limit, total, totalPages } }`. If geo params provided, each store includes a `distance` field (km).

#### `GET /stores/slug/:slug` / `GET /stores/:id` — `200`

Full store object (name, slug, description, address, city, phone, email, coordinates, images, operatingHours, rating, isOpen, etc.).

#### `GET /stores/:id/pickup-times` — `200`

Array of pickup time slot objects: `[{ time: "10:00", available: true }, ...]`

#### `GET /stores/:storeId/gallery` — `200`

Array of gallery image URL strings.

#### `GET /stores/:storeId/hours` — `200`

```json
{
  "operatingHours": { "monday": { "open": "07:00", "close": "22:00" }, ... },
  "specialHours": []
}
```

#### `GET /stores/:storeId/location` — `200`

```json
{
  "address": "123 Coffee St",
  "city": "Phnom Penh",
  "latitude": 11.556,
  "longitude": 104.928,
  "googleMapsUrl": "..."
}
```

#### `GET /stores/:storeId/menu` — `200`

Paginated product list: `{ data: Product[], pagination: { ... } }`

---

## 4. Products & Categories

Browse the menu, categories, and product details.

| Method | Endpoint                           | Description                                | Auth Required |
| ------ | ---------------------------------- | ------------------------------------------ | ------------- |
| GET    | `/products`                        | Get products with filtering and pagination | No            |
| GET    | `/products/search`                 | Search for products                        | No            |
| GET    | `/products/slug/:slug`             | Get product details by slug                | No            |
| GET    | `/products/:id`                    | Get product details by ID                  | No            |
| GET    | `/products/:id/customizations`     | Get product customization options          | No            |
| GET    | `/products/:id/addons`             | Get compatible add-ons for a product       | No            |
| GET    | `/categories`                      | Get all product categories                 | No            |
| GET    | `/categories/slug/:slug`           | Get category details by slug               | No            |
| GET    | `/categories/:id`                  | Get category details by ID                 | No            |
| GET    | `/categories/:id/subcategories`    | Get subcategories                          | No            |
| GET    | `/categories/:categoryId/products` | Get products in a specific category        | No            |
| GET    | `/addons`                          | Get all available add-ons                  | No            |

### Payloads

#### `GET /products` — Query Parameters

| Field         | Type               | Required | Constraints                 |
| ------------- | ------------------ | -------- | --------------------------- |
| categoryId    | string             | ❌       | Valid MongoDB ObjectId      |
| isFeatured    | string             | ❌       | `"true"` or `"false"`       |
| isBestSelling | string             | ❌       | `"true"` or `"false"`       |
| isAvailable   | string             | ❌       | `"true"` or `"false"`       |
| tags          | string \| string[] | ❌       | Single tag or array of tags |
| minPrice      | number             | ❌       | ≥ 0                         |
| maxPrice      | number             | ❌       | ≥ 0                         |
| search        | string             | ❌       | Trimmed text                |

#### `GET /products/search` — Query Parameters

| Field         | Type               | Required | Constraints                 |
| ------------- | ------------------ | -------- | --------------------------- |
| q             | string             | ✅       | Min 1 char, trimmed         |
| categoryId    | string             | ❌       | Valid MongoDB ObjectId      |
| isFeatured    | string             | ❌       | `"true"` or `"false"`       |
| isBestSelling | string             | ❌       | `"true"` or `"false"`       |
| tags          | string \| string[] | ❌       | Single tag or array of tags |
| minPrice      | number             | ❌       | ≥ 0                         |
| maxPrice      | number             | ❌       | ≥ 0                         |

### Responses

#### `GET /products` — `200`

Paginated: `{ data: Product[], pagination: { page, limit, total, totalPages } }`

#### `GET /products/search` — `200`

Paginated: `{ data: Product[], pagination: { ... } }`

#### `GET /products/slug/:slug` / `GET /products/:id` — `200`

Full product object (name, slug, description, images, basePrice, currency, sizes, category, tags, allergens, nutritionalInfo, preparationTime, isAvailable, isFeatured, rating, etc.).

#### `GET /products/:id/customizations` — `200`

```json
{ "productId": "664abc...", "customizations": { "size": [...], "sugarLevel": [...], "iceLevel": [...], "coffeeLevel": [...] } }
```

#### `GET /products/:id/addons` — `200`

```json
{ "productId": "664abc...", "addOns": [{ "_id": "...", "name": "Extra Shot", "price": 0.5, ... }] }
```

#### `GET /categories` — `200`

Array of category objects.

#### `GET /categories/slug/:slug` / `GET /categories/:id` — `200`

Full category object (name, slug, description, imageUrl, parentId, displayOrder, etc.).

#### `GET /categories/:id/subcategories` — `200`

Array of child category objects.

#### `GET /categories/:categoryId/products` — `200`

Paginated: `{ data: Product[], pagination: { ... } }`

#### `GET /addons` — `200`

```json
{ "addOns": [{ "_id": "...", "name": "Whipped Cream", "price": 0.75, ... }], "count": 5 }
```

---

## 5. Search & Favorites

Personalized search history and favorite products.

| Method | Endpoint                   | Description                          | Auth Required |
| ------ | -------------------------- | ------------------------------------ | ------------- |
| GET    | `/search`                  | Global search across products/stores | No            |
| GET    | `/search/suggestions`      | Get autocomplete search suggestions  | No            |
| GET    | `/search/recent`           | Get user's recent searches           | Yes           |
| DELETE | `/search/recent`           | Clear all recent searches            | Yes           |
| DELETE | `/search/recent/:searchId` | Delete a specific search entry       | Yes           |
| GET    | `/favorites`               | Get user's favorite products         | Yes           |
| POST   | `/favorites/:productId`    | Add product to favorites             | Yes           |
| DELETE | `/favorites/:productId`    | Remove product from favorites        | Yes           |

### Payloads

#### `GET /search` — Query Parameters

| Field | Type   | Required | Constraints                                      |
| ----- | ------ | -------- | ------------------------------------------------ |
| q     | string | ✅       | Min 1 char, max 100 chars, trimmed               |
| type  | string | ❌       | Enum: `store`, `product`, `all` (default: `all`) |
| limit | number | ❌       | Positive integer, max 50 (default: 20)           |

#### `GET /search/suggestions` — Query Parameters

| Field | Type   | Required | Constraints                            |
| ----- | ------ | -------- | -------------------------------------- |
| q     | string | ✅       | Min 1 char, max 100 chars, trimmed     |
| limit | number | ❌       | Positive integer, max 10 (default: 10) |

#### `POST /favorites/:productId` — Path Parameters

| Field     | Type   | Required | Constraints            |
| --------- | ------ | -------- | ---------------------- |
| productId | string | ✅       | Valid MongoDB ObjectId |

#### `DELETE /favorites/:productId` — Path Parameters

| Field     | Type   | Required | Constraints            |
| --------- | ------ | -------- | ---------------------- |
| productId | string | ✅       | Valid MongoDB ObjectId |

### Responses

#### `GET /search` — `200`

```json
{
  "stores": [
    {
      "id": "...",
      "name": "...",
      "slug": "...",
      "address": "...",
      "city": "...",
      "imageUrl": "...",
      "rating": 4.5,
      "isOpen": true,
      "score": 1.5
    }
  ],
  "products": [
    {
      "id": "...",
      "name": "...",
      "slug": "...",
      "description": "...",
      "basePrice": 3.5,
      "currency": "USD",
      "images": [],
      "isAvailable": true,
      "rating": 4.2,
      "score": 1.2
    }
  ],
  "totalResults": 12
}
```

#### `GET /search/suggestions` — `200`

Array of suggestion strings: `["Cappuccino", "Caramel Latte", ...]`

#### `GET /search/recent` — `200`

Array of search history objects: `[{ "id": "...", "query": "latte", "searchType": "all", "resultsCount": 5, "createdAt": "..." }]`

#### `DELETE /search/recent` — `200`

`data: null`

#### `DELETE /search/recent/:searchId` — `200`

`data: null`

#### `GET /favorites` — `200`

```json
{
  "favorites": [
    {
      "favoriteId": "...",
      "productId": "...",
      "name": "...",
      "slug": "...",
      "description": "...",
      "images": [],
      "basePrice": 3.5,
      "currency": "USD",
      "isAvailable": true,
      "rating": 4.5,
      "totalReviews": 20,
      "categoryId": "...",
      "preparationTime": 5,
      "favoritedAt": "..."
    }
  ],
  "count": 3
}
```

#### `POST /favorites/:productId` — `200`

```json
{ "message": "Product added to favorites", "productId": "664abc..." }
```

#### `DELETE /favorites/:productId` — `200`

```json
{ "message": "Product removed from favorites", "productId": "664abc..." }
```

---

## 6. Shopping Cart

Manage the active shopping cart.

| Method | Endpoint              | Description                            | Auth Required |
| ------ | --------------------- | -------------------------------------- | ------------- |
| GET    | `/cart`               | Get current cart contents              | Yes           |
| POST   | `/cart/items`         | Add item to cart                       | Yes           |
| PATCH  | `/cart/items/:itemId` | Update item quantity in cart           | Yes           |
| DELETE | `/cart/items/:itemId` | Remove item from cart                  | Yes           |
| DELETE | `/cart`               | Clear entire cart                      | Yes           |
| POST   | `/cart/validate`      | Validate cart items and availability   | Yes           |
| PATCH  | `/cart/address`       | Set delivery address for the cart      | Yes           |
| PATCH  | `/cart/notes`         | Add special instructions/notes to cart | Yes           |
| GET    | `/cart/summary`       | Get cart totals and summary            | Yes           |

### Payloads

#### `POST /cart/items`

| Field         | Type     | Required | Constraints                    |
| ------------- | -------- | -------- | ------------------------------ |
| productId     | string   | ✅       | Valid MongoDB ObjectId         |
| quantity      | number   | ✅       | Positive integer, min 1        |
| customization | object   | ❌       | See Customization object below |
| addOns        | string[] | ❌       | Array of MongoDB ObjectIds     |
| notes         | string   | ❌       | Max 500 chars, trimmed         |

**Customization Object:**
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| size | string | ❌ | Enum: `small`, `medium`, `large` |
| sugarLevel | string | ❌ | Enum: `none`, `low`, `medium`, `high` |
| iceLevel | string | ❌ | Enum: `none`, `low`, `medium`, `high` |
| coffeeLevel | string | ❌ | Enum: `single`, `double`, `triple` |

#### `PATCH /cart/items/:itemId`

| Field    | Type   | Required | Constraints             |
| -------- | ------ | -------- | ----------------------- |
| quantity | number | ✅       | Positive integer, min 1 |

#### `PATCH /cart/address`

| Field     | Type   | Required | Constraints            |
| --------- | ------ | -------- | ---------------------- |
| addressId | string | ✅       | Valid MongoDB ObjectId |

#### `PATCH /cart/notes`

| Field | Type   | Required | Constraints             |
| ----- | ------ | -------- | ----------------------- |
| notes | string | ✅       | Max 1000 chars, trimmed |

### Responses

#### `GET /cart` — `200`

Full cart object with populated items (product details, customizations, addOns, quantities, prices).

#### `POST /cart/items` — `200`

Returns the updated cart object.

#### `PATCH /cart/items/:itemId` — `200`

Returns the updated cart object.

#### `DELETE /cart/items/:itemId` — `200`

Returns the updated cart object.

#### `DELETE /cart` — `200`

Returns the cleared cart object.

#### `POST /cart/validate` — `200`

```json
{ "isValid": true, "issues": [] }
```

Or if issues exist:

```json
{
  "isValid": false,
  "issues": [
    {
      "itemId": "...",
      "productId": "...",
      "issue": "Product no longer available"
    }
  ]
}
```

#### `PATCH /cart/address` — `200`

Returns the updated cart object.

#### `PATCH /cart/notes` — `200`

Returns the updated cart object.

#### `GET /cart/summary` — `200`

```json
{
  "itemCount": 3,
  "subtotal": 12.5,
  "discount": 0,
  "tax": 1.25,
  "deliveryFee": 2.0,
  "total": 15.75
}
```

---

## 7. Checkout & Payments

Processing orders and payments.

| Method | Endpoint                              | Description                       | Auth Required |
| ------ | ------------------------------------- | --------------------------------- | ------------- |
| POST   | `/checkout/validate`                  | Pre-checkout validation           | Yes           |
| POST   | `/checkout`                           | Create a checkout session         | Yes           |
| GET    | `/checkout/:checkoutId`               | Get checkout session details      | Yes           |
| GET    | `/checkout/payment-methods`           | Get available payment methods     | Yes           |
| POST   | `/checkout/:checkoutId/apply-coupon`  | Apply discount coupon             | Yes           |
| DELETE | `/checkout/:checkoutId/remove-coupon` | Remove discount coupon            | Yes           |
| GET    | `/checkout/delivery-charges`          | Calculate delivery fees           | Yes           |
| POST   | `/checkout/:checkoutId/confirm`       | Confirm checkout and create order | Yes           |
| POST   | `/payments/:orderId/intent`           | Create a payment intent           | Yes           |
| POST   | `/payments/:orderId/confirm`          | Confirm payment completion        | Yes           |

### Payloads

#### `POST /checkout/validate`

No request body required — uses authenticated user's cart.

#### `POST /checkout`

No request body required — creates session from authenticated user's cart.

#### `POST /checkout/:checkoutId/apply-coupon`

| Field      | Type   | Required | Constraints                                        |
| ---------- | ------ | -------- | -------------------------------------------------- |
| couponCode | string | ✅       | Min 1 char, max 50 chars, trimmed, auto-uppercased |

#### `POST /checkout/:checkoutId/confirm`

| Field         | Type   | Required | Constraints                           |
| ------------- | ------ | -------- | ------------------------------------- |
| paymentMethod | string | ✅       | Enum: `ABA`, `ACLEDA`, `Wing`, `Cash` |

#### `GET /checkout/delivery-charges` — Query Parameters

| Field     | Type   | Required | Constraints            |
| --------- | ------ | -------- | ---------------------- |
| addressId | string | ✅       | Valid MongoDB ObjectId |

#### `POST /payments/:orderId/confirm`

| Field          | Type   | Required | Constraints                           |
| -------------- | ------ | -------- | ------------------------------------- |
| paymentMethod  | string | ✅       | Enum: `ABA`, `ACLEDA`, `Wing`, `Cash` |
| transactionId  | string | ❌       | Min 1 char, max 100 chars, trimmed    |
| paymentDetails | object | ❌       | Free-form key-value pairs             |

### Responses

#### `POST /checkout/validate` — `200`

```json
{ "isValid": true, "errors": [], "warnings": [] }
```

#### `POST /checkout` — `201`

```json
{
  "id": "checkout_abc...",
  "userId": "664abc...",
  "cartId": "664def...",
  "items": [
    {
      "productId": "...",
      "productName": "...",
      "productImage": "...",
      "quantity": 2,
      "unitPrice": 3.5,
      "totalPrice": 7.0,
      "customization": {},
      "addOns": [],
      "notes": ""
    }
  ],
  "subtotal": 7.0,
  "discount": 0,
  "tax": 0.7,
  "deliveryFee": 2.0,
  "total": 9.7,
  "deliveryAddress": "664ghi...",
  "promoCode": null,
  "expiresAt": "2026-03-04T13:00:00.000Z",
  "createdAt": "2026-03-04T12:45:00.000Z"
}
```

#### `GET /checkout/:checkoutId` — `200`

Same shape as `POST /checkout` response.

#### `GET /checkout/payment-methods` — `200`

```json
[{ "id": "ABA", "name": "ABA Bank", "type": "bank_transfer", "isActive": true }, ...]
```

#### `POST /checkout/:checkoutId/apply-coupon` — `200`

Returns updated checkout session with `promoCode: { code, discountAmount }` populated.

#### `DELETE /checkout/:checkoutId/remove-coupon` — `200`

Returns updated checkout session with `promoCode: null`.

#### `GET /checkout/delivery-charges` — `200`

```json
{ "deliveryFee": 2.5, "currency": "USD" }
```

#### `POST /checkout/:checkoutId/confirm` — `201`

Returns the created order object.

#### `POST /payments/:orderId/intent` — `200`

```json
{
  "id": "...",
  "orderId": "...",
  "amount": 9.7,
  "currency": "USD",
  "paymentMethod": "ABA",
  "status": "pending",
  "providerIntentId": "ABA-INTENT-...",
  "createdAt": "..."
}
```

#### `POST /payments/:orderId/confirm` — `200`

```json
{
  "order": {
    "id": "...",
    "orderNumber": "ORD-001",
    "status": "confirmed",
    "paymentStatus": "completed",
    "total": 9.7
  },
  "transactionId": "TXN-..."
}
```

---

## 8. Orders & Tracking

Order history and real-time tracking.

| Method | Endpoint                    | Description                       | Auth Required |
| ------ | --------------------------- | --------------------------------- | ------------- |
| GET    | `/orders`                   | Get user's order history          | Yes           |
| GET    | `/orders/:orderId`          | Get specific order details        | Yes           |
| GET    | `/orders/:orderId/tracking` | Get real-time order tracking info | Yes           |
| GET    | `/orders/:orderId/invoice`  | Get order invoice                 | Yes           |
| POST   | `/orders/:orderId/cancel`   | Cancel a pending order            | Yes           |
| POST   | `/orders/:orderId/rate`     | Rate and review an order          | Yes           |
| POST   | `/orders/:orderId/reorder`  | Add items from past order to cart | Yes           |

### Payloads

#### `GET /orders` — Query Parameters

| Field    | Type   | Required | Constraints                                                                                       |
| -------- | ------ | -------- | ------------------------------------------------------------------------------------------------- |
| page     | number | ❌       | Positive integer (default: 1)                                                                     |
| limit    | number | ❌       | Positive integer, max 100 (default: 20)                                                           |
| status   | string | ❌       | Enum: `pending_payment`, `confirmed`, `preparing`, `ready`, `picked_up`, `completed`, `cancelled` |
| storeId  | string | ❌       | Valid MongoDB ObjectId                                                                            |
| dateFrom | date   | ❌       | ISO date string                                                                                   |
| dateTo   | date   | ❌       | ISO date string                                                                                   |

#### `POST /orders/:orderId/cancel`

| Field  | Type   | Required | Constraints                        |
| ------ | ------ | -------- | ---------------------------------- |
| reason | string | ✅       | Min 1 char, max 500 chars, trimmed |

#### `POST /orders/:orderId/rate`

| Field  | Type   | Required | Constraints             |
| ------ | ------ | -------- | ----------------------- |
| rating | number | ✅       | Integer, 1-5            |
| review | string | ❌       | Max 1000 chars, trimmed |

#### `POST /orders/:orderId/reorder`

No request body required — reorders from the specified order.

### Responses

#### `GET /orders` — `200`

Paginated: `{ items: Order[], pagination: { page, limit, total, totalPages } }`

#### `GET /orders/:orderId` — `200`

Full order object (orderNumber, status, paymentStatus, items with product details, totals, store info, delivery address, timestamps, etc.).

#### `GET /orders/:orderId/tracking` — `200`

```json
{
  "orderNumber": "ORD-001",
  "status": "preparing",
  "statusHistory": [{ "status": "confirmed", "timestamp": "...", "notes": "" }],
  "estimatedReadyTime": "...",
  "actualReadyTime": null,
  "pickedUpAt": null
}
```

#### `GET /orders/:orderId/invoice` — `200`

Returns PDF binary (`Content-Type: application/pdf`).

#### `POST /orders/:orderId/cancel` — `200`

Returns the updated order object with `status: "cancelled"`.

#### `POST /orders/:orderId/rate` — `200`

`data: null`

#### `POST /orders/:orderId/reorder` — `200`

`data: null` (items added to cart).

---

## 9. Notifications

Push and in-app notifications.

| Method | Endpoint                          | Description                            | Auth Required |
| ------ | --------------------------------- | -------------------------------------- | ------------- |
| POST   | `/notifications/devices/register` | Register device for push notifications | Yes           |
| DELETE | `/notifications/devices/:tokenId` | Unregister device                      | Yes           |
| GET    | `/notifications`                  | Get user notifications                 | Yes           |
| GET    | `/notifications/unread-count`     | Get count of unread notifications      | Yes           |
| PATCH  | `/notifications/:id/read`         | Mark notification as read              | Yes           |
| PATCH  | `/notifications/read-all`         | Mark all notifications as read         | Yes           |
| DELETE | `/notifications/:id`              | Delete a notification                  | Yes           |
| DELETE | `/notifications`                  | Delete all notifications               | Yes           |
| GET    | `/notifications/settings`         | Get notification preferences           | Yes           |
| PATCH  | `/notifications/settings`         | Update notification preferences        | Yes           |

### Payloads

#### `POST /notifications/devices/register`

| Field       | Type   | Required | Constraints                    |
| ----------- | ------ | -------- | ------------------------------ |
| fcmToken    | string | ✅       | Firebase Cloud Messaging token |
| deviceType  | string | ✅       | Enum: `ios`, `android`         |
| deviceId    | string | ❌       | Unique device identifier       |
| deviceModel | string | ❌       | e.g. "iPhone 15 Pro"           |
| osVersion   | string | ❌       | e.g. "17.2"                    |
| appVersion  | string | ❌       | e.g. "1.0.0"                   |

#### `GET /notifications` — Query Parameters

| Field  | Type   | Required | Constraints                       |
| ------ | ------ | -------- | --------------------------------- |
| type   | string | ❌       | Notification type filter          |
| isRead | string | ❌       | `"true"` or `"false"`             |
| limit  | number | ❌       | Positive integer (default: 50)    |
| skip   | number | ❌       | Non-negative integer (default: 0) |

#### `PATCH /notifications/settings`

| Field               | Type    | Required | Constraints     |
| ------------------- | ------- | -------- | --------------- |
| orderUpdates        | boolean | ❌       | Default: `true` |
| promotions          | boolean | ❌       | Default: `true` |
| announcements       | boolean | ❌       | Default: `true` |
| systemNotifications | boolean | ❌       | Default: `true` |

### Responses

#### `POST /notifications/devices/register` — `200`

Returns the device token object (fcmToken, deviceType, deviceId, etc.).

#### `DELETE /notifications/devices/:tokenId` — `200`

`data: null`

#### `GET /notifications` — `200`

Array of notification objects: `[{ _id, type, title, message, imageUrl, isRead, createdAt, ... }]`

#### `GET /notifications/unread-count` — `200`

```json
{ "count": 5 }
```

#### `PATCH /notifications/:id/read` — `200`

`data: null`

#### `PATCH /notifications/read-all` — `200`

`data: null`

#### `DELETE /notifications/:id` — `200`

`data: null`

#### `DELETE /notifications` — `200`

`data: null`

#### `GET /notifications/settings` — `200`

```json
{
  "orderUpdates": true,
  "promotions": true,
  "announcements": true,
  "systemNotifications": true
}
```

#### `PATCH /notifications/settings` — `200`

Returns the updated settings object.

---

## 10. Support & Announcements

Help center and promotional content.

| Method | Endpoint                        | Description                         | Auth Required |
| ------ | ------------------------------- | ----------------------------------- | ------------- |
| GET    | `/announcements`                | Get active announcements/promotions | No            |
| GET    | `/announcements/:id`            | Get specific announcement details   | No            |
| POST   | `/announcements/:id/view`       | Track announcement view             | No            |
| POST   | `/announcements/:id/click`      | Track announcement click            | No            |
| GET    | `/support/faq`                  | Get frequently asked questions      | No            |
| POST   | `/support/tickets`              | Create a support ticket             | Yes           |
| GET    | `/support/tickets`              | Get user's support tickets          | Yes           |
| GET    | `/support/tickets/:id`          | Get ticket details and messages     | Yes           |
| POST   | `/support/tickets/:id/messages` | Send message in a ticket            | Yes           |
| GET    | `/support/tickets/:id/messages` | Get ticket conversation history     | Yes           |

### Payloads

#### `GET /support/faq` — Query Parameters

| Field    | Type   | Required | Constraints         |
| -------- | ------ | -------- | ------------------- |
| category | string | ❌       | FAQ category filter |

#### `POST /support/tickets`

| Field    | Type   | Required | Constraints                                     |
| -------- | ------ | -------- | ----------------------------------------------- |
| subject  | string | ✅       | Ticket subject/title                            |
| category | string | ✅       | Ticket category (e.g. "order_issue", "payment") |
| message  | string | ✅       | Initial message body                            |
| priority | string | ❌       | Ticket priority level                           |

#### `GET /support/tickets` — Query Parameters

| Field    | Type   | Required | Constraints                    |
| -------- | ------ | -------- | ------------------------------ |
| status   | string | ❌       | Ticket status filter           |
| category | string | ❌       | Category filter                |
| page     | number | ❌       | Positive integer (default: 1)  |
| limit    | number | ❌       | Positive integer (default: 20) |

#### `POST /support/tickets/:id/messages`

| Field       | Type   | Required | Constraints              |
| ----------- | ------ | -------- | ------------------------ |
| message     | string | ✅       | Message body text        |
| attachments | array  | ❌       | Array of attachment URLs |

### Responses

#### `GET /announcements` — `200`

Array of active announcement objects (title, description, imageUrl, actionUrl, startDate, endDate, etc.).

#### `GET /announcements/:id` — `200`

Full announcement object.

#### `POST /announcements/:id/view` — `200`

`data: null`

#### `POST /announcements/:id/click` — `200`

`data: null`

#### `GET /support/faq` — `200`

Array of FAQ objects: `[{ _id, question, answer, category, displayOrder }]`

#### `POST /support/tickets` — `201`

Returns the created ticket object.

#### `GET /support/tickets` — `200`

Paginated: `{ tickets: Ticket[], pagination: { ... } }`

#### `GET /support/tickets/:id` — `200`

Full ticket object with conversation messages.

#### `POST /support/tickets/:id/messages` — `201`

Returns the created message object.

#### `GET /support/tickets/:id/messages` — `200`

Array of message objects: `[{ _id, senderId, senderRole, message, attachments, createdAt }]`

---

## 11. Configuration & Miscellaneous

| Method | Endpoint                 | Description                              | Auth Required |
| ------ | ------------------------ | ---------------------------------------- | ------------- |
| GET    | `/config/app`            | Get public application configuration     | No            |
| GET    | `/config/delivery-zones` | Get active delivery zones                | No            |
| GET    | `/config/health`         | API health check                         | No            |
| POST   | `/upload`                | Upload a file (e.g., support attachment) | Yes           |
| DELETE | `/upload`                | Delete an uploaded file                  | Yes           |

### Payloads

#### `POST /upload`

File upload via `multipart/form-data`. Refer to your HTTP client's multipart support.

#### `DELETE /upload`

Provide the file identifier to delete (typically the file URL or ID returned from upload).

### Responses

#### `GET /config/app` — `200`

Key-value map of public configuration: `{ "appName": "Corner Coffee", "currency": "USD", ... }`

#### `GET /config/delivery-zones` — `200`

Array of delivery zone objects: `[{ _id, name, deliveryFee, minOrderAmount, coordinates, estimatedDeliveryTime, isActive }]`

#### `GET /config/health` — `200`

```json
{
  "status": "ok",
  "uptime": 12345.67,
  "timestamp": "2026-03-04T12:00:00.000Z",
  "database": { "status": "connected" }
}
```

#### `POST /upload` — `200`

```json
{
  "url": "https://res.cloudinary.com/...",
  "public_id": "abc123",
  "format": "image/jpeg",
  "original_name": "photo.jpg",
  "size": 102400
}
```

#### `DELETE /upload` — `200`

`data: null`
