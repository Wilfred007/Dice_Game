import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const pseudoRandomLudo = buildModule("pseudoRandomLudo", (m) => {


  const pseudoRandomLudo = m.contract("pseudoRandomLudo");

  return { pseudoRandomLudo };
});

export default pseudoRandomLudo;
