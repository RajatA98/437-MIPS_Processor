`include "cpu_types_pkg.vh"

interface fetch_decode_if;
  // import types
  import cpu_types_pkg::*;

  logic flush, enable;
  word_t imemaddr_ID, instr_ID, imemload, imemaddr;

  modport fd (
    input flush, enable, imemaddr, imemload,
    output imemaddr_ID, instr_ID
   );


endinterface
`endif
