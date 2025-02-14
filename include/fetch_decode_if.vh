`ifndef FETCH_DECODE_IF_VH
`define FETCH_DECODE_IF_VH
`include "cpu_types_pkg.vh"

interface fetch_decode_if;
  // import types
  import cpu_types_pkg::*;

  logic flush, enable;
  word_t next_addr, next_addr_ID,imemaddr_ID, instr_ID, imemload, imemaddr;

  modport fd (
    input flush, enable, next_addr, imemaddr, imemload,
    output next_addr_ID, imemaddr_ID, instr_ID
   );


endinterface
`endif
