/*
  Warnings:

  - You are about to drop the column `fingerprint` on the `Transaction` table. All the data in the column will be lost.
  - You are about to drop the column `genesisTransactionId` on the `Transaction` table. All the data in the column will be lost.
  - You are about to drop the column `connectionHash` on the `users` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "fingerprint",
DROP COLUMN "genesisTransactionId";

-- AlterTable
ALTER TABLE "users" DROP COLUMN "connectionHash";
