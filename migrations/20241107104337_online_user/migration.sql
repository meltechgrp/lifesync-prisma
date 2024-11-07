-- CreateTable
CREATE TABLE "OnlineUser" (
    "id" SERIAL NOT NULL,
    "userId" UUID NOT NULL,
    "deviceUniqueId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OnlineUser_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "OnlineUser_userId_deviceUniqueId_key" ON "OnlineUser"("userId", "deviceUniqueId");
