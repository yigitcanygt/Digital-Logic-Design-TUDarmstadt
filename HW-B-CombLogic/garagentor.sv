`timescale 1ns / 1ns

module garagentor

    ( input   logic  Auf, Zu, Offen, Geschlossen, Ueberlast, I, // Input wires
      output  logic E_U, E_D, E_W, E_R);                        // Outputs

/* ====================================== INSERT CODE HERE ====================================== */
  
    // Motor nach oben:
    assign E_U = (~Ueberlast & Auf & ~Zu & ~Offen) |
                 ( Ueberlast & ~Offen );

    // Motor nach unten:
    assign E_D = (~Ueberlast & Zu & ~Auf & ~Geschlossen);

    // Weißes Licht: Tor bewegt sich
    assign E_W = E_U | E_D;

    // Rote Warnleuchte: beim Schließen oder Überlast
    assign E_R = I & (E_D | Ueberlast);

/* ============================================================================================== */

endmodule
