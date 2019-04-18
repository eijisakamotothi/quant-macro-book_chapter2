program main_discretization
! ���C���t�@�C��:
! ��ԕϐ��Ƒ���ϐ��𗣎U������2���ԃ��f��������.

    use mod_types
    use mod_my_econ_fcn
    use mod_generate_grid

    implicit none

    ! *** �J���u���[�V���� ***
    real(dp), parameter :: beta  = 0.985**30     ! �������q
    real(dp), parameter :: gamma = 2.0           ! ���ΓI�댯���x
    real(dp), parameter :: rent  = 1.025**30-1.0 ! �����q��

    ! *** �p�����[�^ ***
    integer, parameter :: nw = 10 ! �����O���b�h�̐�
    integer, parameter :: na = 40 ! ���~�O���b�h�̐�
    real(dp), parameter :: w_max = 1.0   ! �����O���b�h�̍ő�l
    real(dp), parameter :: w_min = 0.1   ! �����O���b�h�̍ŏ��l
    real(dp), parameter :: a_max = 1.0   ! ���~�O���b�h�̍ő�l
    real(dp), parameter :: a_min = 0.025 ! ���~�O���b�h�̍ŏ��l

    ! *** ���[�J���ϐ� ***
    integer :: i, j, maxl
    real(dp) :: cons, time_begin, time_end
    real(dp), dimension(na) :: grid_a
    real(dp), dimension(nw) :: grid_w
    real(dp), dimension(nw) :: pol
    real(dp), dimension(na, nw) :: obj
    !---------------------------------

    ! �v�Z���Ԃ��J�E���g�J�n
    call cpu_time( time_begin )

    write(*,*) ""
    write(*,*) " -+-+-+- Solve two period model using discretization -+-+-+-"

    ! �O���b�h�|�C���g���v�Z
    call grid_uniform(w_min, w_max, nw, grid_w)
    call grid_uniform(a_min, a_max, na, grid_a)

    ! ������(w,a)�̑g�ݍ��킹�ɂ��Đ��U���p���v�Z

    ! ������
    obj = 0.0

    do i = 1,nw
        do j = 1,na
            cons = grid_w(i) - grid_a(j)
            if (cons > 0.0) then
                obj(j, i) = CRRA(cons, gamma) + beta*CRRA((1.0+rent)*grid_a(j), gamma)
            else
                ! ������l�̏ꍇ�A�y�i���e�B��^���Ă��̒l���I�΂�Ȃ��悤�ɂ���
                obj(j, i) = -10000.0;
            end if
        end do
    end do

    ! ���p���ő�ɂ��鑀��ϐ���T���o���F����֐�

    ! ������
    pol = 0.0

    ! �ew�ɂ��Đ��U���p���ő�ɂ���a��T��
    do i = 1,nw
        maxl = maxloc(obj(:,i), dim=1)
        pol(i) = grid_a(maxl)
    end do

    ! �v�Z���Ԃ��J�E���g�I��
    call cpu_time( time_end )
    write (*,"(' Program finished sucessfully in', f12.9, ' seconds')") time_end - time_begin

    ! �v�Z���ʂ��e�L�X�g�t�@�C���ŏo��
    open (10, file='policy_function.txt')
        do i = 1,nw
            write (10,*) pol(i)
        end do
    close (10)

end program main_discretization
