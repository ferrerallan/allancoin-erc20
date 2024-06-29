import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const AllanCoinModule = buildModule("AllanCoinModule", (m) => {
  const AllanCoin = m.contract("AllanCoin");

  return { AllanCoin };
});


export default AllanCoinModule;
