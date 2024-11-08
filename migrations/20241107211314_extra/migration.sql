-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "UserActivityType" ADD VALUE 'SentConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'ReceivedConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'AcceptedConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'RejectedConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'CancelledConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'IgnoredConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'BlockedConnectionRequest';
ALTER TYPE "UserActivityType" ADD VALUE 'BlockedUser';
ALTER TYPE "UserActivityType" ADD VALUE 'DisconnectedConnection';
