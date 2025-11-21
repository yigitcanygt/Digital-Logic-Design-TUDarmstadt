`timescale 1ns/1ns

module garagentor_tb;

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic         ERROR;              // Will be 1 if any test failed
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic Auf, Zu, Offen, Geschlossen, Ueberlast, I;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic   E_U, E_D, E_W, E_R;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  garagentor uut(
                          .Auf(Auf),
                          .Zu(Zu),
                          .Offen(Offen),
                          .Geschlossen(Geschlossen),
                          .Ueberlast(Ueberlast),
                          .I(I),
                          .E_U(E_U),
                          .E_D(E_D),
                          .E_W(E_W),
                          .E_R(E_R));
  //***********************************************************//

always #1 I = ~I; // blink impulse intialization

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("garagentor.vcd");
    $timeformat(-9, 0, " ns", 8);
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR       = 1'b0;
    I = 1'b0;
    #1;

    $display("************* STARTING SIMULATION *************");
    // test 1: check functionality under normal circumstances
    // check_normal_functionality(input logic R_in, Y_in, G_in,    E_R_expected, E_G_expected, E_Y_expected)
    check_normal_functionality(0,0,0,1,0,0,0,0);
    check_normal_functionality(0,1,0,1,0,0,0,0);
    check_normal_functionality(1,0,0,0,1,0,1,0);
    check_normal_functionality(1,1,0,0,0,0,0,0);


    check_ueberlast_functionality();


    $display("************* SIMULATION COMPLETE *************");

    if (ERROR == 0) begin
      $display("All tests succeeded");
    end else begin
      $display("THERE WERE ERRORS");
    end

    $finish;
  end
  //***********************************************************//

  //********************* SIMULATION TASKS ********************//
  task  check_normal_functionality(input logic Auf_in, Zu_in, Offen_in, Geschlossen_in, E_U_expected, E_D_expected, E_W_expected, E_R_expected);
    $display("Starting test for normal case: Auf=%b, Zu=%b, Offen=%b, Geschlossen=%b", Auf_in, Zu_in, Offen_in, Geschlossen_in);
    #1;
    Ueberlast = 0;
    Auf = Auf_in;
    Zu = Zu_in;
    Offen = Offen_in;
    Geschlossen = Geschlossen_in;
    #2.5;

    if (E_R_expected === 1) begin
	    for (int i = 0; i < 10; i++) begin
	        #1;
	        if (E_R === I) begin
	            //$display("blinking...");
	        end else begin
	            $display("red is not blinking properly: FAILED");
	            ERROR       = 1'b1;
	        end
	    end
    end

    if ((E_U === E_U_expected) & (E_D === E_D_expected) & (E_W === E_W_expected)) begin
        $display("success");
    end else begin
        $display("error, something is not working properly: E_U=%b, expected %b -- E_D=%b, expected %b -- E_W=%b, expected %b", E_U, E_U_expected, E_D, E_D_expected, E_W, E_W_expected, E_R);
        ERROR       = 1'b1;
    end
  endtask

  task  check_ueberlast_functionality();
    Ueberlast = 1;
    Offen = 0;
   	Geschlossen = 0;

    // CASE 1
    Auf = 0;
    Zu = 0;
    #1;

    $display("Starting test for ueberlast case: Auf=%b, Zu=%b, Offen=%b, Geschlossen=%b", Auf, Zu, Offen, Geschlossen);

    if ((E_U === 1) & (E_D === 0) & (E_W === 1)) begin
 			$display("success");
  		end else begin
 			$display("error, something is not working properly: E_U=%b, expected %b -- E_D=%b, expected %b -- E_W=%b, expected %b", E_U, 1, E_D, 0, E_W, 1);
  		ERROR       = 1'b1;
   	end

    // CASE 2
    Auf = 0;
    Zu = 1;
    #1;

    $display("Starting test for ueberlast case: Auf=%b, Zu=%b, Offen=%b, Geschlossen=%b", Auf, Zu, Offen, Geschlossen);

    if ((E_U === 1) & (E_D === 0) & (E_W === 1)) begin
 			$display("success");
  		end else begin
 			$display("error, something is not working properly: E_U=%b, expected %b -- E_D=%b, expected %b -- E_W=%b, expected %b", E_U, 1, E_D, 0, E_W, 1);
  		ERROR       = 1'b1;
   	end
  endtask

//***********************************************************//

endmodule
