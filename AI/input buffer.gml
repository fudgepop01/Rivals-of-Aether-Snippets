
//####################################################################################################
//  DESCRIPTION: 
//      this simulates an input buffer for ALL the inputs. 
//      this likely won't be needed but it's here just in-case.
//  NOTES: 
//    - I recommend trimming this down to only use the inputs you NEED accurate buffers for
//      otherwise it can get very slow with complex AI systems
//####################################################################################################


////////////////////////////////////////////////////
//    ai_init.gml
////////////////////////////////////////////////////

ai_input_buffer = array_create(17, -1);

////////////////////////////////////////////////////
//    ai_update.gml
////////////////////////////////////////////////////
// input buffer indexes 
// - IF YOU MODIFY THE ARRAY IN THE FUNCTION YOU MUST UPDATE THESE
#macro INPB_ATTACK 0
#macro INPB_SPECIAL 1
#macro INPB_JUMP 2
#macro INPB_SHIELD 3
#macro INPB_LEFT 4
#macro INPB_RIGHT 5
#macro INPB_UP 6
#macro INPB_DOWN 7
#macro INPB_LEFT_HARD 8
#macro INPB_RIGHT_HARD 9
#macro INPB_UP_HARD 10
#macro INPB_DOWN_HARD 11
#macro INPB_LEFT_STRONG 12
#macro INPB_RIGHT_STRONG 13
#macro INPB_UP_STRONG 14
#macro INPB_DOWN_STRONG 15
#macro INPB_TAUNT 16

// input values
#macro INP_ATTACK 1 << 0
#macro INP_SPECIAL 1 << 1
#macro INP_JUMP 1 << 2
#macro INP_SHIELD 1 << 3

#macro INP_LEFT 1 << 4
#macro INP_RIGHT 1 << 5
#macro INP_UP 1 << 6
#macro INP_DOWN 1 << 7

#macro INP_LEFT_HARD 1 << 8
#macro INP_RIGHT_HARD 1 << 9
#macro INP_UP_HARD 1 << 10
#macro INP_DOWN_HARD 1 << 11

#macro INP_LEFT_STRONG 1 << 12
#macro INP_RIGHT_STRONG 1 << 13
#macro INP_UP_STRONG 1 << 14
#macro INP_DOWN_STRONG 1 << 15

#macro INP_TAUNT 1 << 16

////////////////////////////////////////////////////
//    usage (ai_update.gml)
////////////////////////////////////////////////////
ai_inputs = 0;
ai_inputs |= INP_LEFT_HARD; // can be any of the INP_* values
process_inputs();


#define process_inputs()
  var input_names = [
    "attack",
    "special",
    "jump",
    "shield",
    "left",
    "right",
    "up",
    "down",
    "left_hard",
    "right_hard",
    "up_hard",
    "down_hard",
    "left_strong",
    "right_strong",
    "up_strong",
    "down_strong",
    "taunt"
  ];

  if (ai_inputs & INP_LEFT_HARD == INP_LEFT_HARD) { ai_input_buffer[@ INPB_RIGHT_HARD] = -1; ai_input_buffer[@ INPB_RIGHT] = -1; }
  if (ai_inputs & INP_RIGHT_HARD == INP_RIGHT_HARD) { ai_input_buffer[@ INPB_LEFT_HARD] = -1; ai_input_buffer[@ INPB_LEFT] = -1; }
  if (ai_inputs & INP_UP_HARD == INP_UP_HARD) { ai_input_buffer[@ INPB_DOWN_HARD] = -1; ai_input_buffer[@ INPB_DOWN] = -1; }
  if (ai_inputs & INP_DOWN_HARD == INP_DOWN_HARD) { ai_input_buffer[@ INPB_UP_HARD] = -1; ai_input_buffer[@ INPB_UP] = -1; }

  var len = array_length_1d(input_names);
  for (var i = 0; i < len; i++) {
    var input_name = input_names[@ i];
    var curr_input_val = 1 << i;
    if (ai_inputs & curr_input_val == curr_input_val) {
      if (ai_prev_inputs & curr_input_val == 0) {
        switch (input_name) {
          case "left":
          case "right":
          case "up": 
          case "down":
            ai_input_buffer[@ i] = 1;
            break;
          default:
            ai_input_buffer[@ i] = 5;
        }
      }
      
      switch(input_name) {
        case "left_hard":
          left_down = true;
          left_pressed = true;
          break;
        case "right_hard":
          right_down = true;
          right_pressed = true;
          break;
        case "up_hard":
          up_down = true;
          up_pressed = true;
          break;
        case "down_hard":
          down_down = true;
          down_pressed = true;
          break;
          // variable_instance_set(self, `${string_copy(input_name, 1, string_length(input_name) - 5)}_down`, true);
          // variable_instance_set(self, `${string_copy(input_name, 1, string_length(input_name) - 5)}_pressed`, true);
          break;
        case "left_strong":
        case "right_strong":
        case "up_strong":
        case "down_strong":
          strong_down = true;
          break;
        default:
          variable_instance_set(self, `${input_name}_down`, true);
          break;
      }
    }

    var curr_buff = ai_input_buffer[@ i];
    if (curr_buff >= 0) { 
      switch(input_name) {
        case "left_hard":
          if (!(ai_prev_prev_inputs & INP_LEFT_HARD == INP_LEFT_HARD && ai_prev_inputs & INP_LEFT_HARD == 0)) continue;
          break;
        case "right_hard":
          if (!(ai_prev_prev_inputs & INP_RIGHT_HARD == INP_RIGHT_HARD && ai_prev_inputs & INP_RIGHT_HARD == 0)) continue;
          break;
        case "up_hard":
          if (!(ai_prev_prev_inputs & INP_UP_HARD == INP_UP_HARD && ai_prev_inputs & INP_UP_HARD == 0)) continue;
          break;
        case "down_hard":
          if (!(ai_prev_prev_inputs & INP_DOWN_HARD == INP_DOWN_HARD && ai_prev_inputs & INP_DOWN_HARD == 0)) continue;
          break;
        default:
      }
      variable_instance_set(self, `${input_name}_pressed`, true); 
      ai_input_buffer[@ i] = curr_buff - 1;
    }
  }
  if (joy_dir != -1) joy_pad_idle = false;
  ai_prev_prev_inputs = ai_prev_inputs;
  ai_prev_inputs = ai_inputs;
