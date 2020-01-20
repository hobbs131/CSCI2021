.text
.global  set_temp_from_ports

# GRADERS NOTE: set_display_from_temp and thermo_update not completed. set_temp_from_ports should be fully functional.
# Also direct division by 64 was used instead of shifts because I wasn't sure how to shift and get remainder.
set_temp_from_ports:

          # Error conditionals for THERMO_SENSOR_PORT (must be between 0 and 64,000)
          cmpw $64000, THERMO_SENSOR_PORT(%rip)
          ja .RETURN_1
          cmpw $0, THERMO_SENSOR_PORT(%rip)
          jb .RETURN_1

          # Error conditionals for THERMO_STATUS_PORT (must be zero or one)
          cmpb $0, THERMO_STATUS_PORT(%rip)
          jb .RETURN_1
          cmpb $1, THERMO_STATUS_PORT(%rip)
          ja .RETURN_1


          # Zero out registers for STATUS/SENSOR ports
          xorq %r8, %r8
          xorq %rcx, %rcx

          # Place SENSOR/STATUS ports in respective registers
          movw THERMO_SENSOR_PORT(%rip), %r8w
          movb THERMO_STATUS_PORT(%rip), %cl

          # Add operation for tenths conversion
          addl $32, %r8d

          # Division operation for tenths conversion
          xorq %rdx, %rdx
          xorq %rax, %rax
          movl %r8d, %eax
          cdq
          movl $64, %r8d
          idivl %r8d
          movl %eax, %r8d

          # Subtraction operation for tenths conversion
          subl $500, %r8d

          # Conditional for fahrenheit conversion
          cmpb $1, %cl
          jne .RETURN_0

          # Multiplication operation for fahrenheit conversion
          movl %r8d, %eax
          imull $9, %r8d

          # Division operation for fahrenheit conversion
          xorq %rdx, %rdx
          xorq %rax, %rax
          movl %r8d, %eax
          cdq
          movl $5, %r8d
          idivl %r8d
          movl %eax, %r8d

          # Add operation for fahrenheit conversion
          addl $320, %r8d

# Success and error return labels, respectively

# Updates struct fields upon success and returns 0
.RETURN_0:
          movw %r8w, (%rdi)
          addq $2, %rdi
          movb %cl, (%rdi)
          movq $0, %rax
          ret
.RETURN_1:
          movq $1, %rax # return 1
          ret
