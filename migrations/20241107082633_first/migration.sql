-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "postgis";

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('PENDING', 'APPROVED', 'FLAGGED');

-- CreateEnum
CREATE TYPE "InviteStatus" AS ENUM ('PENDING', 'ACCEPTED', 'CANCELED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('OPEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "ReportStatus" AS ENUM ('PENDING', 'OPEN', 'ON_HOLD', 'RESOLVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "TransactionStatus" AS ENUM ('PENDING', 'PROCESSING', 'SUCCESS', 'FAILED', 'CANCELED');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('DEBIT', 'DEPOSIT', 'REVERSED', 'TOPUP', 'WITHDRAWAL', 'FEE_DEBIT', 'FEE_DEPOSIT');

-- CreateEnum
CREATE TYPE "OnlineStatus" AS ENUM ('ONLINE', 'OFFLINE');

-- CreateEnum
CREATE TYPE "RequestStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELED');

-- CreateEnum
CREATE TYPE "AppPlatform" AS ENUM ('IOS', 'ANDROID', 'WEB');

-- CreateEnum
CREATE TYPE "OrderProvider" AS ENUM ('PAYSTACK', 'FLUTTERWAVE', 'FLICK');

-- CreateEnum
CREATE TYPE "DevicePNTokenStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "UserActivityType" AS ENUM ('UserLoggedIn', 'UserLoggedOut', 'UserOnline', 'UserOffline', 'InitiatedOrder', 'SuccessfulOrder', 'FailedOrder', 'CancelledOrder', 'AddedBankAccount', 'DepositSuccess', 'DepositFailed');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('SEEN', 'UNREAD', 'READ');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('PAYMENT_DEPOSIT', 'DELIVERY_WAYBILL_ADDED', 'DELIVERY_ITEM_DELIVERED', 'DELIVERY_CONFIRMED');

-- CreateEnum
CREATE TYPE "NotificationCategory" AS ENUM ('UPDATES', 'REQUESTS');

-- CreateEnum
CREATE TYPE "ShippingMethod" AS ENUM ('PICKUP', 'DELIVERY');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'VERIFIED', 'DEACTIVATED', 'SUSPENDED', 'BANNED', 'DELETED');

-- CreateEnum
CREATE TYPE "ReportReferenceType" AS ENUM ('PROFILE', 'TRANSACTION');

-- CreateEnum
CREATE TYPE "ReportType" AS ENUM ('PICKUP_NOT_RECEIVED', 'AFTER_PICKUP_ISSUE', 'DELIVERY_NO_WAYBILL_ADDED', 'DELIVERY_SHIPPING_ISSUE', 'DELIVERY_ARRIVED_ISSUE', 'AFTER_DELIVERY_RECEIPT_ISSUE');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'USER', 'DOCTOR');

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'NGN',
    "fee" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "walletId" TEXT NOT NULL,
    "type" "TransactionType",
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "comment" TEXT,
    "source" TEXT,
    "note" TEXT,
    "metadata" JSONB,
    "fingerprint" TEXT,
    "genesisTransactionId" TEXT,
    "requestId" TEXT,
    "relatedTransactionIds" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "orderId" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "amount" DOUBLE PRECISION,
    "currency" TEXT NOT NULL DEFAULT 'NGN',
    "status" "OrderStatus" NOT NULL DEFAULT 'OPEN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "closedAt" TIMESTAMP(3),
    "userId" TEXT NOT NULL,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "heartRates" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "heartRates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "temperatures" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "temperatures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bloodPressures" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "systolic" DOUBLE PRECISION,
    "diastolic" DOUBLE PRECISION,
    "value" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bloodPressures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bloodOxygens" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bloodOxygens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stepsRecords" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "count" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stepsRecords_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sosMessages" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sosMessages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FileRecord" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "size" INTEGER,
    "mimetype" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "ratio" DOUBLE PRECISION,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "FileRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Request" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" "RequestStatus" NOT NULL DEFAULT 'PENDING',
    "userId" TEXT NOT NULL,
    "message" TEXT,
    "email" VARCHAR(255),
    "firstName" VARCHAR(255),
    "lastName" VARCHAR(255),
    "phoneNumber" VARCHAR(20) NOT NULL,

    CONSTRAINT "Request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "caseId" SERIAL NOT NULL,
    "userId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "ReportStatus" NOT NULL DEFAULT 'PENDING',
    "meta" JSONB NOT NULL,
    "type" "ReportType",
    "referenceType" "ReportReferenceType",
    "referenceId" TEXT,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Address" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "street" TEXT,
    "city" TEXT,
    "town" TEXT,
    "lga" TEXT,
    "state" TEXT,
    "country" TEXT,
    "userId" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ownerId" TEXT NOT NULL,
    "status" "NotificationStatus" NOT NULL DEFAULT 'UNREAD',
    "type" "NotificationType" NOT NULL,
    "category" "NotificationCategory" NOT NULL,
    "transactionId" TEXT,
    "requestId" TEXT,
    "inviteId" TEXT,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserActivity" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "meta" JSONB,
    "activity" "UserActivityType" NOT NULL,

    CONSTRAINT "UserActivity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DevicePNToken" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "userId" TEXT,
    "did" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" "DevicePNTokenStatus" NOT NULL DEFAULT 'ACTIVE',
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DevicePNToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invite" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "InviteStatus" NOT NULL DEFAULT 'PENDING',
    "inviteeId" TEXT NOT NULL,
    "inviterId" TEXT NOT NULL,

    CONSTRAINT "Invite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "email" VARCHAR(255),
    "firstName" VARCHAR(255),
    "lastName" VARCHAR(255),
    "middleName" VARCHAR(255),
    "username" VARCHAR(255),
    "phoneNumber" VARCHAR(20) NOT NULL,
    "intlPhoneNumber" VARCHAR(20) NOT NULL,
    "countryCode" VARCHAR(3) NOT NULL DEFAULT 'NG',
    "isPhoneVerified" BOOLEAN NOT NULL DEFAULT false,
    "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "dob" TIMESTAMP(3),
    "height" DOUBLE PRECISION,
    "weight" DOUBLE PRECISION,
    "gender" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "photoId" TEXT,
    "role" "Role" NOT NULL DEFAULT 'USER',
    "connectionHash" TEXT,
    "parentId" TEXT,
    "deletedAt" TIMESTAMP(3),
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminAllowedEmail" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "allowedPages" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdminAllowedEmail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "email" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "VerificationToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminUserSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "AdminUserSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PasswordResetTokens" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "PasswordResetTokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserOnlineStatus" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "userId" TEXT NOT NULL,
    "status" "OnlineStatus" NOT NULL DEFAULT 'ONLINE',
    "deviceUniqueId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserOnlineStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthToken" (
    "id" TEXT NOT NULL,
    "uid" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "expiredAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "deviceUniqueId" TEXT,

    CONSTRAINT "AuthToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_SosFamilyMembers" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_uid_key" ON "Transaction"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "Order_uid_key" ON "Order"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "FileRecord_uid_key" ON "FileRecord"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "FileRecord_path_key" ON "FileRecord"("path");

-- CreateIndex
CREATE INDEX "FileRecord_path_idx" ON "FileRecord"("path");

-- CreateIndex
CREATE UNIQUE INDEX "Request_uid_key" ON "Request"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "Request_email_key" ON "Request"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Report_uid_key" ON "Report"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "Address_uid_key" ON "Address"("uid");

-- CreateIndex
CREATE INDEX "Address_userId_idx" ON "Address"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Notification_uid_key" ON "Notification"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "UserActivity_uid_key" ON "UserActivity"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "DevicePNToken_uid_key" ON "DevicePNToken"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "DevicePNToken_did_key" ON "DevicePNToken"("did");

-- CreateIndex
CREATE INDEX "DevicePNToken_userId_idx" ON "DevicePNToken"("userId");

-- CreateIndex
CREATE INDEX "DevicePNToken_did_idx" ON "DevicePNToken"("did");

-- CreateIndex
CREATE UNIQUE INDEX "Invite_uid_key" ON "Invite"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "users_uid_key" ON "users"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_intlPhoneNumber_key" ON "users"("intlPhoneNumber");

-- CreateIndex
CREATE INDEX "users_username_phoneNumber_idx" ON "users"("username", "phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "users_countryCode_phoneNumber_key" ON "users"("countryCode", "phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "AdminAllowedEmail_uid_key" ON "AdminAllowedEmail"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "AdminAllowedEmail_email_key" ON "AdminAllowedEmail"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_email_token_key" ON "VerificationToken"("email", "token");

-- CreateIndex
CREATE UNIQUE INDEX "PasswordResetTokens_token_key" ON "PasswordResetTokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "UserOnlineStatus_uid_key" ON "UserOnlineStatus"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "AuthToken_uid_key" ON "AuthToken"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "_SosFamilyMembers_AB_unique" ON "_SosFamilyMembers"("A", "B");

-- CreateIndex
CREATE INDEX "_SosFamilyMembers_B_index" ON "_SosFamilyMembers"("B");

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "heartRates" ADD CONSTRAINT "heartRates_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "temperatures" ADD CONSTRAINT "temperatures_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bloodPressures" ADD CONSTRAINT "bloodPressures_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bloodOxygens" ADD CONSTRAINT "bloodOxygens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stepsRecords" ADD CONSTRAINT "stepsRecords_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sosMessages" ADD CONSTRAINT "sosMessages_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Request" ADD CONSTRAINT "Request_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Address" ADD CONSTRAINT "Address_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "Request"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_inviteId_fkey" FOREIGN KEY ("inviteId") REFERENCES "Invite"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserActivity" ADD CONSTRAINT "UserActivity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DevicePNToken" ADD CONSTRAINT "DevicePNToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invite" ADD CONSTRAINT "Invite_inviteeId_fkey" FOREIGN KEY ("inviteeId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invite" ADD CONSTRAINT "Invite_inviterId_fkey" FOREIGN KEY ("inviterId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_photoId_fkey" FOREIGN KEY ("photoId") REFERENCES "FileRecord"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VerificationToken" ADD CONSTRAINT "VerificationToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminUserSession" ADD CONSTRAINT "AdminUserSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PasswordResetTokens" ADD CONSTRAINT "PasswordResetTokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserOnlineStatus" ADD CONSTRAINT "UserOnlineStatus_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuthToken" ADD CONSTRAINT "AuthToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SosFamilyMembers" ADD CONSTRAINT "_SosFamilyMembers_A_fkey" FOREIGN KEY ("A") REFERENCES "sosMessages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SosFamilyMembers" ADD CONSTRAINT "_SosFamilyMembers_B_fkey" FOREIGN KEY ("B") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
