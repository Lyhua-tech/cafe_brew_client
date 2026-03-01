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
