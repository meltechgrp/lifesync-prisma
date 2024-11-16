/*
  Warnings:

  - You are about to drop the column `username` on the `users` table. All the data in the column will be lost.
  - Added the required column `password` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "users_username_key";

-- DropIndex
DROP INDEX "users_username_phoneNumber_idx";

-- AlterTable
ALTER TABLE "users" DROP COLUMN "username",
ADD COLUMN     "password" VARCHAR(255) NOT NULL;

-- CreateIndex
CREATE INDEX "users_phoneNumber_idx" ON "users"("phoneNumber");
