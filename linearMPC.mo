within ;

package linearMPC
  "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
// Please cite the following publication if you are using the library for your own research:
//   S. Hoelemann and D. Abel,
//   Modelica Predictive Control -- An MPC Library for Modelica,
//   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

  package Basic
    "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    constant Integer step_response_model = 0;
    constant Integer state_space_model = 1;
    constant Integer transfer_function_model = 0;

    partial model linMPCpartial
      "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
    // Please cite the following publication if you are using the library for your own research:
    //   S. Hoelemann and D. Abel,
    //   Modelica Predictive Control -- An MPC Library for Modelica,
    //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

      type ModelType
        extends Integer(min=0, max=2);
        annotation (Evaluate=true, choices(
          choice = step_response_model,
          choice = state_space_model,
          choice = transfer_function_model));
      end ModelType;

      type ConstraintsHandlingType
        extends Integer(min=0, max=1);
        annotation (Evaluate=true, choices(
          choice=0 "unconstrained MPC",
          choice=1 "constrained MPC"));
      end ConstraintsHandlingType;

      type DisturbanceInputtype
        extends Integer(min=0, max=1);
        annotation (Evaluate=true, choices(
          choice=0 "current mesurement",
          choice=1 "prospective trajectory"));
      end DisturbanceInputtype;

      type DisturbanceHandlingType
        extends Integer(min=0, max=1);
        annotation (Evaluate=true, choices(
          choice=0 "off",
          choice=1 "on"));
      end DisturbanceHandlingType;

    // controller parameters
      parameter Integer p = 1 "number of controlled variables"
                                                            annotation(Dialog(enable=true, tab="General", group="controller settings"));
      parameter Integer m = 1 "number of manipulated variables"
                                                              annotation(Dialog(enable=true, tab="General", group="controller settings"));
      parameter Integer Nl = 1 "lower prediction horizon" annotation(Dialog(enable=true, tab="General", group="controller settings"));
      parameter Integer Np = 1 "upper prediction horizon" annotation(Dialog(enable=true, tab="General", group="controller settings"));
      parameter Integer Nu = 1 "control horizon" annotation(Dialog(enable=true, tab="General", group="controller settings"));
      parameter Real Ts = 1 "sample time (/s)" annotation(Dialog(enable=true, tab="General", group="controller settings"));

    // cost function settings
      parameter Real[:,:] Q = identity(p) "weighting matrix"
                                                       annotation(Dialog(enable=true, tab="General", group="cost function"));
      parameter Real[:,:] R = identity(m) "weighting matrix"
                                                       annotation(Dialog(enable=true, tab="General", group="cost function"));
    // model parameters
      replaceable parameter ModelType modelType annotation(Dialog(enable=false, tab="Model parameters", group="model parameters"));
      parameter DisturbanceHandlingType biasCompensation = 1
        "compensate prediction bias" annotation(Dialog(enable=true, tab="Model parameters", group="disturbance handling"));
      parameter Integer q = 0 "number of measurable disturbance variables" annotation(Dialog(enable=true, tab="Model parameters", group="disturbance handling"));
      parameter DisturbanceInputtype DisturbanceInput = 0
        "form of disturbance input" annotation(Dialog(enable=(q>0), tab="Model parameters", group="disturbance handling"));

    // constraints settings
      parameter ConstraintsHandlingType constraints = 1 "constraints handling" annotation(Dialog(enable=true, tab="Constraints", group=""));
      parameter Integer[:] boundedDeltaUmin = zeros(0)
        "vector of indices of lower bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in manipulated variables"));
      parameter Real[:] deltaUmin = -1*ones(0) "vector of lower bounds"
                                                 annotation(Dialog(enable=(size(boundedDeltaUmin,1)>0) and (constraints==1), tab="Constraints", group="changes in manipulated variables"));
      parameter Integer[:] boundedDeltaUmax = zeros(0)
        "vector of indices of upper bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in manipulated variables"));
      parameter Real[:] deltaUmax = 1*ones(0) "vector of upper bounds"
                                                  annotation(Dialog(enable=(size(boundedDeltaUmax,1)>0) and (constraints==1), tab="Constraints", group="changes in manipulated variables"));
      parameter Integer[:] boundedUmin = zeros(0)
        "vector of indices of lower bounded variables"
                                                   annotation(Dialog(enable=(constraints==1), tab="Constraints", group="manipulated variables"));
      parameter Real[:] Umin = -1*ones(0) "vector of lower bounds"
                                            annotation(Dialog(enable=(size(boundedUmin,1)>0) and (constraints==1), tab="Constraints", group="manipulated variables"));
      parameter Integer[:] boundedUmax = zeros(0)
        "vector of indices of upper bounded variables"
                                                   annotation(Dialog(enable=(constraints==1), tab="Constraints", group="manipulated variables"));
      parameter Real[:] Umax = 1*ones(0) "vector of upper bounds"
                                             annotation(Dialog(enable=(size(boundedUmax,1)>0) and (constraints==1), tab="Constraints", group="manipulated variables"));
      parameter Integer[:] boundedYmin = zeros(0)
        "vector of indices of lower bounded variables"
                                                   annotation(Dialog(enable=(constraints==1), tab="Constraints", group="controlled variables"));
      parameter Real[:] Ymin = -1*ones(0) "vector of lower bounds"
                                            annotation(Dialog(enable=(size(boundedYmin,1)>0) and (constraints==1), tab="Constraints", group="controlled variables"));
      parameter Integer[:] boundedYmax = zeros(0)
        "vector of indices of upper bounded variables"
                                                   annotation(Dialog(enable=(constraints==1), tab="Constraints", group="controlled variables"));
      parameter Real[:] Ymax = 1*ones(0) "vector of upper bounds"
                                             annotation(Dialog(enable=(size(boundedYmax,1)>0) and (constraints==1), tab="Constraints", group="controlled variables"));
      parameter Integer[:] boundedDeltaYmin = zeros(0)
        "vector of indices of lower bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in controlled variables"));
      parameter Real[:] deltaYmin = -1*ones(0) "vector of lower bounds"
                                                 annotation(Dialog(enable=(size(boundedDeltaYmin,1)>0) and (constraints==1), tab="Constraints", group="changes in controlled variables"));
      parameter Integer[:] boundedDeltaYmax = zeros(0)
        "vector of indices of upper bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in controlled variables"));
      parameter Real[:] deltaYmax = 1*ones(0) "vector of upper bounds"
                                                  annotation(Dialog(enable=(size(boundedDeltaYmax,1)>0) and (constraints==1), tab="Constraints", group="changes in controlled variables"));

    //QP Solver settings
    public
      parameter Real rho = 100
        "penelization of quadratic constraints violation"                        annotation(Dialog(enable=true, tab="Advanced", group="QP Solver settings"));
      parameter Real cvio_start = 10
        "start value of allowed constraints violation"                              annotation(Dialog(enable=true, tab="Advanced", group="QP Solver settings"));
      parameter Real eps = 1E-5 "precision of the optimization" annotation(Dialog(enable=true, tab="Advanced", group="QP Solver settings"));
      parameter Real mue = 5 "gain for increasing outer iteration variable" annotation(Dialog(enable=true, tab="Advanced", group="QP Solver settings"));
      parameter Real beta = 0.2 "gain factor for step size adaption" annotation(Dialog(enable=true, tab="Advanced", group="QP Solver settings"));
    protected
      parameter Basic.QPSolverRecord SolverParams(rho=rho,cvio_start=cvio_start,eps=eps,mue=mue,beta=beta);

    public
      parameter Real[m] u_start = zeros(m)
        "start values for manipulated variables"                                 annotation(Dialog(enable=true, tab="General", group="initialization"));

      // expand weighting matrices
    protected
      parameter Real Qexp[(Np-Nl+1)*p,(Np-Nl+1)*p] = Basic.repmatDiag(Q,size(Q,1),size(Q,2),Np-Nl+1);
      parameter Real Rexp[m*Nu,m*Nu] = Basic.repmatDiag(R,size(R,1),size(R,2),Nu);

    protected
      Modelica.Blocks.Discrete.UnitDelay unitDelay[m](samplePeriod=Ts, y_start=
            u_start)
        annotation (Placement(transformation(extent={{60,-40},{40,-20}},
              rotation=0)));
      Modelica.Blocks.Math.Add add[m] annotation (Placement(transformation(
              extent={{30,-10},{50,10}}, rotation=0)));

    public
      Modelica.Blocks.Interfaces.RealInput r[(Np - Nl + 1)*p]
        "reference trajectory" annotation (Placement(transformation(extent={{
                -120,60},{-80,100}}, rotation=0)));
      Modelica.Blocks.Interfaces.RealInput d[(1 + DisturbanceInput*(Np-Nl))*q]
        "changes in measureable disturbances" annotation (Placement(
            transformation(extent={{-120,-100},{-80,-60}}, rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput u[m] "actuating variables"
        annotation (Placement(transformation(extent={{80,-20},{120,20}},
              rotation=0)));

    protected
      discrete Real deltaU[m*Nu] "entire trajectory";
    public
      discrete Real deltaUk[m] "controller output";

    initial equation
      u = u_start;

      assert(size(Q,1)==p,"");
      assert(size(Q,2)==p,"");
      assert(size(R,1)==m,"");
      assert(size(R,2)==m,"");

    equation
      when sample(0, Ts) then
        //calculate controller output
        deltaUk = deltaU[1:m];
        add.u1 = deltaUk;
      end when;

      connect(add.y, u) annotation (Line(
          points={{51,0},{100,0}},
          color={0,0,127},
          thickness=0.5));
      connect(unitDelay.y, add.u2) annotation (Line(
          points={{39,-30},{20,-30},{20,-6},{28,-6}},
          color={0,0,127},
          thickness=0.5));
      connect(unitDelay.u, add.y) annotation (Line(
          points={{62,-30},{70,-30},{70,0},{51,0}},
          color={0,0,127},
          thickness=0.5));
      annotation (Diagram(graphics={Text(
              extent={{20,-30},{40,-40}},
              lineColor={0,0,255},
              lineThickness=0.5,
              textString=
                   "u(k-1)"), Text(
              extent={{10,18},{30,8}},
              lineColor={0,0,255},
              lineThickness=0.5,
              textString=
                   "delta_u(k)")}),Icon(graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              lineThickness=1,
              fillPattern=FillPattern.Sphere,
              fillColor={255,103,103}),
            Text(
              extent={{-80,80},{80,-80}},
              lineColor={0,0,0},
              lineThickness=1,
              fillPattern=FillPattern.VerticalCylinder,
              textString=
                   "MPC"),
            Text(
              extent={{-78,82},{-6,40}},
              lineColor={0,0,0},
              lineThickness=1,
              fillPattern=FillPattern.Sphere,
              fillColor={255,125,125},
              textString=
                   "linear"),
            Text(
              extent={{-100,-80},{100,-100}},
              lineColor={255,255,255},
              pattern=LinePattern.Dot,
              lineThickness=1,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString=
                   "MPC Toolbox")}));
    end linMPCpartial;

    record QPSolverRecord
      parameter Real rho = 100 "penelization of constraints violation";
      parameter Real cvio_start = 10
        "start value of allowed constraints violation";
      parameter Real eps = 1E-5 "precision of the optimization";
      parameter Real mue = 5 "gain for increasing outer iteration variable";
      parameter Real beta = 0.2 "gain factor for step size adaption";
    end QPSolverRecord;

    record ConstraintsRecord
      Integer Nc = 0 "number of constraints";

      // constraint definition on delta_u
      Integer[:] boundedDeltaUmin = zeros(0)
        "vector of indices of lower bounded variables";
      Real[:] deltaUmin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedDeltaUmax = zeros(0)
        "vector of indices of upper bounded variables";
      Real[:] deltaUmax = 1*ones(0) "vector of upper bounds";

      // constraints definition on u
      Integer[:] boundedUmin = zeros(0)
        "vector of indices of lower bounded variables";
      Real[:] Umin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedUmax = zeros(0)
        "vector of indices of upper bounded variables";
      Real[:] Umax = 1*ones(0) "vector of upper bounds";

      // constraints definition on y
      Integer[:] boundedYmin = zeros(0)
        "vector of indices of lower bounded variables";
      Real[:] Ymin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedYmax = zeros(0)
        "vector of indices of upper bounded variables";
      Real[:] Ymax = 1*ones(0) "vector of upper bounds";

      // constraints definition on delta_y
      Integer[:] boundedDeltaYmin = zeros(0);
      Real[:] deltaYmin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedDeltaYmax = zeros(0);
      Real[:] deltaYmax = 1*ones(0) "vector of upper bounds";

      // constraints definiton on state variables
      Integer[:] boundedXmin = zeros(0)
        "vector of indices of lower bounded variables";
      Real[:] Xmin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedXmax = zeros(0)
        "vector of indices of upper bounded variables";
      Real[:] Xmax = 1*ones(0) "vector of upper bounds";
      // constraints definition on changes in state variables
      Integer[:] boundedDeltaXmin = zeros(0)
        "vector of indices of lower bounded variables";
      Real[:] deltaXmin = -1*ones(0) "vector of lower bounds";
      Integer[:] boundedDeltaXmax = zeros(0)
        "vector of indices of upper bounded variables";
      Real[:] deltaXmax = 1*ones(0) "vector of upper bounds";

      // ------------------------------

      Integer[:] expBoundedYmin = zeros(0)
        "expanded vector of indices of lower bounded variables";
      Integer[:] expBoundedYmax = zeros(0)
        "expanded vector of indices of upper bounded variables";
      Integer[:] expBoundedXmin = zeros(0)
        "expanded vector of indices of lower bounded variables";
      Integer[:] expBoundedXmax = zeros(0)
        "expanded vector of indices of upper bounded variables";
      Integer[:] expBoundedDeltaXmin = zeros(0)
        "expanded vector of indices of lower bounded variables";
      Integer[:] expBoundedDeltaXmax = zeros(0)
        "expanded vector of indices of upper bounded variables";
      Integer[:] expBoundedDeltaYmin = zeros(0)
        "expanded vector of indices of lower bounded variables";
      Integer[:] expBoundedDeltaYmax = zeros(0)
        "expanded vector of indices of upper bounded variables";

    end ConstraintsRecord;

    function MoveBuffer
      input Real[:] bufferIn;
      input Real[:] valueIn;
      input Integer numVar;
      input Integer bufferlength;

      output Real[numVar*bufferlength] bufferOut;

    algorithm
      for j in 1:(bufferlength-1) loop
        bufferOut[(j-1)*numVar+1:j*numVar] := bufferIn[j*numVar + 1:(j+1)*numVar];
      end for;
      bufferOut[((bufferlength-1)*numVar+1):(bufferlength*numVar)] := valueIn;
    end MoveBuffer;

    function expandBoundedX
      "expands 'boundedX' over horizon 'Nl'; 'n' gives length of x"
      input Integer[:] boundedX;
      input Integer Nl;
      input Integer n;

      output Integer[size(boundedX,1)*Nl] outvec;

    algorithm
      if size(boundedX,1) > 0 then
        for j in 1:Nl loop
          outvec[((j-1)*size(boundedX,1)+1):(j*size(boundedX,1))] := boundedX + (j-1)*n*ones(size(boundedX,1));
        end for;
      else
        outvec := zeros(0);
      end if;
    end expandBoundedX;

    function repmatIdentity1
      "repeats the identity matrix of size 'n' 'i'-times along the first dimension"
      input Integer n "size of identity matrix to be repeated";
      input Integer i "number of repetitions";

      output Real[i*n,n] mat;

    algorithm
      for j in 1:i loop
        mat[(j-1)*n+1:j*n,1:n] :=identity(n);
      end for;
    end repmatIdentity1;

    function repVec
      "returns the 'm'-times concatenation of 'inVec' so that outVec = [inVec; inVec; inVec;, ...]"
      input Real[:] inVec "vector to be repeated";
      input Integer len "length of inVec";
      input Integer m "how often";

      output Real[m*len] outVec;

    algorithm
      for i in 1:m loop
        outVec[(i-1)*len+1:i*len] := inVec[1:len];
      end for;
    end repVec;

    function repmat1
      "repeats the identity matrix of size 'n' 'i'-times along the first dimension"
      input Real A[:,:];
      input Integer m "number of rows of A";
      input Integer n "number of columns of A";
      input Integer i "number of repetitions";

      output Real[i*m,n] mat;

    algorithm
      for j in 1:i loop
        mat[(j-1)*m+1:j*m,1:n] := A;
      end for;
    end repmat1;

    function GreaterZero
      "Returns true if the vector 'a' contains at least one element greater than zero, otherwise false"

      input Real[:] a;

      output Boolean out;

    protected
     Integer i;

    algorithm
      out := false;
      i := 1;
      while ((i <= size(a,1)) and (out == false)) loop
        out := (a[i] > 0);
        i := i + 1;
      end while;

    end GreaterZero;

    function repmatDiag
      "repeats the m x n matrix A p times along the diagonal of B"
      input Real[:,:] A;
      input Integer m;
      input Integer n;
      input Integer p;

      output Real[p*m,p*n] B;

    algorithm
      B := zeros(p*m,p*n);
      for j in 1:p loop
        B[((j-1)*m+1):(j*m),((j-1)*n+1):(j*n)] := A;
      end for;

    end repmatDiag;
  end Basic;

  package Solver
    function QPSolve
      "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
    // Please cite the following publication if you are using the library for your own research:
    //   S. Hoelemann and D. Abel,
    //   Modelica Predictive Control -- An MPC Library for Modelica,
    //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    // solves the linear inequality constrained quadratic program
    // min[J(x) = 1/2*x^T*H*x + G^T*x] subject to A*x <= b
    // using a logarithmic barrier function method

      input Real[:,:] H;
      input Real[:] G;
      input Real[:,:] A;
      input Real[:] b;

      input Integer n "dimension of the optimization problem";
      input Integer m "number of constraints";

      input Real[:] Xstart "start value for the iteration";

      output Real[n] x;

    protected
      Real[n] Xiterate "iteration variable of x";
      Real[n] DeltaX "search direction of Newton iteration";
      Integer t;
      Real tNewton "step length of Newton iteration";

      Real[n] Grad "gradient of F";
      Real[n,n] Hessian "hessian matrix of F";
      Real[n,n] invHessian "inverse of the hessian matrix";
      Real[m,m] C "auxiliary matrix for calculating gradient and hessian";
      Real[m,m] invC "auxiliary matrix for calculating gradient and hessian";

      Boolean StopOuterIteration = false;
      Boolean StopInnerIteration = false;

      Integer NumIter "total number of Newton iterations";

    algorithm
      // start value for t
      t := 1;
      NumIter := 0;
      Xiterate := Xstart;
      assert(Basic.GreaterZero(A*Xiterate-b)==false,"ERROR: infeasible Xstart");

      // outer iteration / minimize F for increasing values of t
      while not StopOuterIteration loop

        // inner iteration / Newton method to solve grad(F(x,t)) = 0
        StopInnerIteration :=false;
        while not StopInnerIteration loop
          NumIter := NumIter + 1;
          // calculate gradient and hessian of F at point Xiterate
          C := diagonal(A*Xiterate-b);
          invC := Modelica.Math.Matrices.inv(C);
          Grad := t*(H*Xiterate + G) - transpose(A)*invC*ones(m);
          Hessian := t*H + transpose(A)*(invC^2)*A;
          invHessian := Modelica.Math.Matrices.inv(Hessian);

          // calculate search direction
          DeltaX := - invHessian*Grad;
          // adapt step length
          tNewton := 1;
          while Basic.GreaterZero(A*(Xiterate+tNewton*DeltaX)-b) loop
            tNewton := 0.2 * tNewton;
          end while;
          // calculate next iterate
          Xiterate := Xiterate + tNewton*DeltaX;
          // verify stopping criterion for inner iteration
          StopInnerIteration := ((invHessian*Grad)*Grad/2) <= 1E-5;
        end while;

        // verify stopping criterion for outer iteration
        StopOuterIteration := (m/t < 1E-5);
        // update t = mue*t
        t := 5*t;
      end while;

      // return result
      x := Xiterate;
      Debug.printScalar(NumIter,"NumIter=");
    end QPSolve;

    function QPSolveSoft
      "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
    // Please cite the following publication if you are using the library for your own research:
    //   S. Hoelemann and D. Abel,
    //   Modelica Predictive Control -- An MPC Library for Modelica,
    //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    // solves the linear inequality constrained quadratic program
    // min[J(x) = 1/2*x^T*H*x + G^T*x] subject to A*x <= b
    // using a logarithmic barrier function method

      input Real[:,:] H;
      input Real[:] G;
      input Real[:,:] A;
      input Real[:] b;

      input Integer n "dimension of the optimization problem";
      input Integer m "number of constraints";
      input Integer mhc "number of hard constraints";

      input Real[:] Xstart "start value for the iteration";

      input Basic.QPSolverRecord rcdPar;

      output Real[n] x;

    protected
      Real[n+1] Xiterate "iteration variable of x";
      Real[n+1] DeltaX "search direction of Newton iteration";
      Real t;
      Real tNewton "step length of Newton iteration";

      Real[n+1] Grad "gradient of F";
      Real[n+1,n+1] Hessian "hessian matrix of F";
      Real[n+1,n+1] invHessian "inverse of the hessian matrix";
      Real[m+1,m+1] C "auxiliary matrix for calculating gradient and hessian";
      Real[m+1,m+1] invC
        "auxiliary matrix for calculating gradient and hessian";

      Real[n+1,n+1] Hsoft;
      Real[n+1] Gsoft;
      Real[m+1,n+1] Asoft;
      Real[m+1] bsoft;

      Boolean StopOuterIteration = false;
      Boolean StopInnerIteration = false;

      Integer NumIter "total number of Newton iterations";

    algorithm
      // expand matrices for soft constraints
      Hsoft := cat(1,cat(2,H,zeros(n,1)),zeros(1,n+1));
      Gsoft := cat(1,G,{rcdPar.rho});
      Asoft := cat(1,cat(2,A,cat(1,zeros(mhc,1),-1*ones(m-mhc,1))),cat(2,zeros(1,n),{{-1}}));
      bsoft := cat(1,b,{0});

      Xiterate := cat(1,Xstart,{rcdPar.cvio_start});
      assert(Basic.GreaterZero(Asoft*Xiterate-bsoft)==false,"ERROR: infeasible Xstart; try increasing start value of allowed constraints violation");
      // outer iteration / minimize F for increasing values of t
      NumIter := 0;

      // start value for t
      t := 1;
      while not StopOuterIteration loop

        // inner iteration / Newton method to solve grad(F(x,t)) = 0
        StopInnerIteration :=false;
        while not StopInnerIteration loop
          NumIter := NumIter + 1;
          // calculate gradient and hessian of F at point Xiterate
          C := diagonal(Asoft*Xiterate-bsoft);
          invC := Modelica.Math.Matrices.inv(C);
          Grad := t*(Hsoft*Xiterate + Gsoft) - transpose(Asoft)*invC*ones(m+1);
          Hessian := t*Hsoft + transpose(Asoft)*(invC^2)*Asoft;
          // invHessian := Modelica.Math.Matrices.inv(Hessian);
          // calculate search direction
          // DeltaX := - invHessian*Grad;
          DeltaX := Modelica.Math.Matrices.solve(Hessian,-Grad);
          // adapt step length
          tNewton := 1;
          while Basic.GreaterZero(Asoft*(Xiterate+tNewton*DeltaX)-bsoft) loop
            tNewton := rcdPar.beta * tNewton;
          end while;
          // calculate next iterate
          Xiterate := Xiterate + tNewton*DeltaX;
          // verify stopping criterion for inner iteration
          //StopInnerIteration := ((invHessian*Grad)*Grad/2) <= rcdPar.eps;
          StopInnerIteration := ((-DeltaX)*Grad/2) <= rcdPar.eps;
        end while;

        // verify stopping criterion for outer iteration
        StopOuterIteration := (m/t < rcdPar.eps);
        // update t = mue*t
        t := rcdPar.mue*t;
      end while;

      // return result
      x := Xiterate[1:end-1];
    end QPSolveSoft;
  end Solver;

  package Debug
    function printScalar

      input Real a;
      input String StrIn;

    algorithm
      Modelica.Utilities.Streams.print(StrIn + String(a));
    end printScalar;

    function printVector

      input Real[:] Vec;
      input String StrIn;

    protected
      String str;
      Integer len;

    algorithm
      Modelica.Utilities.Streams.print(StrIn);
      len := size(Vec,1);
      for i in 1:len loop
        str := "  | " + String(Vec[i]) + " |";
        Modelica.Utilities.Streams.print(str);
      end for;

    end printVector;

    function printMatrix

      input Real[:,:] Mat;
      input String StrIn;

    protected
      String str;

    algorithm
      Modelica.Utilities.Streams.print(StrIn);
      for i in 1:size(Mat,1) loop
        str := "  | ";
        for j in 1:size(Mat,2) loop
          str := str + String(Mat[i,j]) + " ";
        end for;
        str := str + "|";
        Modelica.Utilities.Streams.print(str);
      end for;

    end printMatrix;

    function printText
        input String str;
    algorithm
        Modelica.Utilities.Streams.print(str);
    end printText;

  end Debug;

  package Signal
        block Sum "Output difference between commanded and feedback input"

          input Modelica.Blocks.Interfaces.RealInput u1
                                        annotation (Placement(transformation(
              extent={{-100,-20},{-60,20}}, rotation=0)));
          input Modelica.Blocks.Interfaces.RealInput u2
            annotation (Placement(transformation(
            origin={0,-80},
            extent={{-20,-20},{20,20}},
            rotation=90)));
          output Modelica.Blocks.Interfaces.RealOutput y
                                         annotation (Placement(transformation(
              extent={{80,-10},{100,10}}, rotation=0)));
        equation
          y = u1 + u2;
          annotation (
            Window(
              x=0.35,
              y=0.02,
              width=0.52,
              height=0.68),
            Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>difference</i> of the
commanded input <b>u1</b> and the feedback
input <b>u2</b>:
</p>
<pre>
    <b>y</b> = <b>u1</b> - <b>u2</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   n = 2
  results in the following equations:
     y = u1 - u2
</pre>
<p><b>Release Notes:</b></p>
<ul>
<li><i>August 7, 1999</i>
       by <a href=\"http://www.op.dlr.de/~otter/\">Martin Otter</a>:<br>
       Realized.
</li>
</ul>
</HTML>
"),         Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Ellipse(
              extent={{-20,20},{20,-20}},
              lineColor={0,0,127},
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid),
            Line(points={{-60,0},{-20,0}}, color={0,0,127}),
            Line(points={{20,0},{80,0}}, color={0,0,127}),
            Line(points={{0,-20},{0,-60}}, color={0,0,127}),
            Text(extent={{-100,110},{100,60}}, textString=
                                                       "%name")}),
            Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Ellipse(
              extent={{-20,20},{20,-20}},
              lineColor={0,0,255},
              pattern=LinePattern.Solid,
              lineThickness=0.25,
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid),
            Line(points={{-60,0},{-20,0}}),
            Line(points={{20,0},{80,0}}),
            Line(points={{0,-20},{0,-60}})}));
        end Sum;

    model NormalizeInput

      parameter Real u0 = 0 "value of operating point";
      parameter Real deltaUmax = 1
        "absolute value of maximal possible change of u";

      Modelica.Blocks.Interfaces.RealInput u
        annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
              rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput y
        annotation (Placement(transformation(extent={{80,-20},{120,20}},
              rotation=0)));

    equation
      y = u*deltaUmax + u0;
      annotation (Diagram(graphics),
                           Icon(graphics={
            Text(
              extent={{-20,20},{100,-100}},
              lineColor={127,0,0},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "u"),
            Line(
              points={{100,100},{-100,-100}},
              color={0,0,0},
              thickness=0.5),
            Text(
              extent={{-100,100},{0,-20}},
              lineColor={170,85,255},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "%%"),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}));
    end NormalizeInput;

    model NormalizeOutput

      parameter Real Y0 "value of operating point";
      parameter Real deltaYmax "absolute value of maximal possible change of y";
      //parameter Real Ymin "minimal value of y";
      //parameter Real Ymax "maximal value of y";

      Modelica.Blocks.Interfaces.RealInput u
        annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
              rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput y
        annotation (Placement(transformation(extent={{80,-20},{120,20}},
              rotation=0)));

    equation
      y = (u - Y0)/deltaYmax;
      annotation (Icon(graphics={
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
            Text(
              extent={{-100,100},{20,-20}},
              lineColor={127,0,0},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "y"),
            Text(
              extent={{0,20},{100,-100}},
              lineColor={170,85,255},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "%%"),
            Line(
              points={{100,100},{-100,-100}},
              color={0,0,0},
              thickness=0.5)}));
    end NormalizeOutput;

    model NormalizeOutputVec

      parameter Integer n = 1 "number of signals";
      parameter Real Y0[n] = zeros(n) "value of operating point";
      parameter Real deltaYmax[n] = ones(n)
        "absolute value of maximal possible change of y";
      //parameter Real Ymin "minimal value of y";
      //parameter Real Ymax "maximal value of y";

      Modelica.Blocks.Interfaces.RealInput u[n]
        annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
              rotation=0)));

      Modelica.Blocks.Interfaces.RealOutput y[n]
        annotation (Placement(transformation(extent={{80,-20},{120,20}},
              rotation=0)));
    equation
      y = Modelica.Math.Matrices.inv(diagonal(deltaYmax))*(u - Y0);
      annotation (Icon(graphics={
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
            Text(
              extent={{-100,100},{20,-20}},
              lineColor={127,0,0},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "y"),
            Text(
              extent={{0,20},{100,-100}},
              lineColor={170,85,255},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "%%"),
            Line(
              points={{100,100},{-100,-100}},
              color={0,0,0},
              thickness=0.5),
            Polygon(
              points={{72,32},{112,12},{72,-8},{72,32}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{76,26},{116,6},{76,-14},{76,26}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-112,8},{-72,-12},{-112,-32},{-112,8}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-116,14},{-76,-6},{-116,-26},{-116,14}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid)}),
                                         Diagram(graphics));
    end NormalizeOutputVec;

    model NormalizeInputVec

      parameter Integer n = 1 "number of signals";
      parameter Real u0[n] = zeros(n) "value of operating point";
      parameter Real deltaUmax[n] = ones(n)
        "absolute value of maximal possible change of u";

      Modelica.Blocks.Interfaces.RealInput[n] u
        annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
              rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput[n] y
        annotation (Placement(transformation(extent={{80,-20},{120,20}},
              rotation=0)));

    equation
      y = diagonal(deltaUmax)*u + u0;
      annotation (Diagram(graphics),
                           Icon(graphics={
            Text(
              extent={{-20,20},{100,-100}},
              lineColor={127,0,0},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "u"),
            Line(
              points={{100,100},{-100,-100}},
              color={0,0,0},
              thickness=0.5),
            Text(
              extent={{-100,100},{0,-20}},
              lineColor={170,85,255},
              fillColor={255,255,170},
              fillPattern=FillPattern.Solid,
              textString=
                   "%%"),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
            Polygon(
              points={{72,32},{112,12},{72,-8},{72,32}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{76,26},{116,6},{76,-14},{76,26}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-116,14},{-76,-6},{-116,-26},{-116,14}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-112,8},{-72,-12},{-112,-32},{-112,8}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid)}));
    end NormalizeInputVec;
  end Signal;

  package FunctionsStepResponse
    "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    function PredictionMatrix
      input Real[:,:,:] S "step response matrix";

      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nu "control horizon";
      input Integer Nm "model horizon";

      input Integer m "number of control systems inputs";
      input Integer p "number of control systems outputs";

      output Real P[(Np-Nl+1)*p,Nu*m] "prediction matrix";

    algorithm
      // check for correct matrix dimensions
      assert(Nm >= 2,"ERROR in step response model definition: Nm must at least be 2");
      assert(size(S,1) >= Nm,"ERROR in disturbance model definition: size 1 of S must be equal to Nm");
      assert(size(S,2) == p,"ERROR in disturbance model definition: size 2 of S must be equal to p");
      assert(size(S,3) == m,"ERROR in disturbance model definition: size 3 of S must be equal to m");

      P := zeros((Np-Nl+1)*p, m*Nu);
      for i in Nl:Np loop
        for j in Nl:min(Nl+Nu-1,Nl+i-1) loop
          if (Nl+i-j) <= Nm then
            P[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i-j,:,:];
          else
            P[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nm,:,:];
          end if;
        end for;
      end for;

    end PredictionMatrix;

    function FreeResponseMatrix
      input Real[:,:,:] S "step response matrix";
      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nm "model horizon";

      input Integer m "number of control systems inputs";
      input Integer p "number of control systems outputs";

      output Real[(Np-Nl+1)*p,m*(Nm-1)] F;

    algorithm
      F := zeros((Np-Nl+1)*p, m*(Nm-1));
      for j in Nl:Np loop
        for i in (Nm-1):-1:1 loop
            if (Nm-i+j) <= Nm then
              F[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*m+1:i*m] := S[Nm-i+j,:,:];
            else
              F[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*m+1:i*m] := S[Nm,:,:];
            end if;
            F[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*m+1:i*m] := F[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*m+1:i*m] - S[Nm-i,:,:];
        end for;
      end for;
    end FreeResponseMatrix;

    function DisturbanceMatrix
      "calculate matrix to predict control variables depending on past and prospective changes of measurable disturbance variables using step a response disturbance model"
      input Real[:,:,:] Sd "step response matrix of measurable disturbances";
      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nmd "model horizon of measurable disturbances";

      input Integer p "number of control systems outputs";
      input Integer q "number of measurable disturbance variables";

      output Real[p*(Np-Nl+1),q*(Nmd-1+Np)] E;

    protected
      Real[p*(Np-Nl+1),q*(Nmd-1)] matH1;
      Real[p*(Np-Nl+1),q*Np] matH2;

    algorithm
      if q > 0 then
        // check for correct matrix dimensions
        assert(Nmd >= 2,"ERROR in disturbance model definition: Nmd must be greater 1 if q > 0");
        assert(size(Sd,1) == Nmd,"ERROR in disturbance model definition: size 1 of Sd must be equal to Nmd");
        assert(size(Sd,2) == p,"ERROR in disturbance model definition: size 2 of Sd must be equal to p");
        assert(size(Sd,3) == q,"ERROR in disturbance model definition: size 3 of Sd must be equal to q");

        // influence of past changes in disturbance variables
        matH1 := zeros(p*(Np - Nl + 1), q*(Nmd - 1));
        for j in Nl:Np loop
          for i in (Nmd - 1):-1:1 loop
            if (Nmd-i+j) <= Nmd then
              matH1[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*q+1:i*q] := Sd[Nmd-i+j,:,:];
            else
              matH1[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*q+1:i*q] := Sd[Nmd,:,:];
            end if;
            matH1[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*q+1:i*q] := matH1[((j-Nl)*p+1):((j-Nl+1)*p),(i-1)*q+1:i*q] - Sd[Nmd-i,:,:];
          end for;
        end for;
        // influence of current and prospective changes in disturbance variables
        matH2 := zeros(p*(Np - Nl + 1), q*Np);
        for j in Nl:Np loop
          for i in Nl:min(Np,Nl+j-1) loop
            if (Nl+j-i) <= Nmd then
              matH2[((j-Nl)*p+1):((j-Nl+1)*p),(i-Nl)*q+1:(i-Nl+1)*q] := Sd[Nl+j-i,:,:];
            else
              matH2[((j-Nl)*p+1):((j-Nl+1)*p),(i-Nl)*q+1:(i-Nl+1)*q] := Sd[Nmd,:,:];
            end if;
          end for;
        end for;
      // construct disturbance matrix
        E := cat(2,matH1,matH2);
      else
        E := zeros(p*(Np-Nl+1),q*(Nmd-1+Np));
      end if;

    end DisturbanceMatrix;

    function ConstraintsMatrix

      input Basic.ConstraintsRecord rcdC;
      input Real[:,:] P "Prediction Matrix";
      input Real[:,:,:] S "step response matrix";

      input Integer p = 1 "number of controlled variables";
      input Integer m = 1 "number of manipulated variables";
      input Integer Nl = 1 "lower prediction horizon";
      input Integer Np = 1 "upper prediction horizon";
      input Integer Nu = 1 "control horizon";
      input Integer Nm = 1 "model horizon";

      output Real[rcdC.Nc,m*Nu] Ac;

    protected
      Integer z;

      Integer[Nu*size(rcdC.boundedDeltaUmin, 1)] vec_H1min;
      Integer[Nu*size(rcdC.boundedDeltaUmax, 1)] vec_H1max;
      Integer[Nu*size(rcdC.boundedUmin, 1)] vec_H2min;
      Integer[Nu*size(rcdC.boundedUmax, 1)] vec_H2max;
      Real[m*Nu,m*Nu] mat_H1;

      Integer[(Np-Nl+1)*size(rcdC.boundedDeltaYmin, 1)] vec_H4min;
      Integer[(Np-Nl+1)*size(rcdC.boundedDeltaYmax, 1)] vec_H4max;
      Real[p*(Np-Nl+1),m*Nu] mat_H2;

    algorithm
      // check for correct array dimensions and indices
      assert(size(rcdC.boundedDeltaUmin,1) <= m, "ERROR in constraint definition of deltaUmin");
      if size(rcdC.boundedDeltaUmin,1) > 0 then
        assert(min(rcdC.boundedDeltaUmin) > 0, "ERROR in constraint definition of deltaUmin");
        assert(max(rcdC.boundedDeltaUmin) <= m, "ERROR in constraint definition of deltaUmin");
        assert(size(rcdC.boundedDeltaUmin,1) == size(rcdC.deltaUmin,1), "ERROR in constraint definition of deltaUmin");
      end if;
      assert(size(rcdC.boundedDeltaUmax,1) <= m, "ERROR in constraint definition of deltaUmax");
      if size(rcdC.boundedDeltaUmax,1) > 0 then
        assert(min(rcdC.boundedDeltaUmax) > 0, "ERROR in constraint definition of deltaUmax");
        assert(max(rcdC.boundedDeltaUmax) <= m, "ERROR in constraint definition of deltaUmax");
        assert(size(rcdC.boundedDeltaUmax,1) == size(rcdC.deltaUmax,1), "ERROR in constraint definition of deltaUmax");
      end if;
      assert(size(rcdC.boundedUmin,1) <= m, "ERROR in constraint definition of Umin");
      if size(rcdC.boundedUmin,1) > 0 then
        assert(min(rcdC.boundedUmin) > 0, "ERROR in constraint definition of Umin");
        assert(max(rcdC.boundedUmin) <= m, "ERROR in constraint definition of Umin");
        assert(size(rcdC.boundedUmin,1) == size(rcdC.Umin,1), "ERROR in constraint definition of Umin");
      end if;
      assert(size(rcdC.boundedUmax,1) <= m, "ERROR in constraint definition of Umax");
      if size(rcdC.boundedUmax,1) > 0 then
        assert(min(rcdC.boundedUmax) > 0, "ERROR in constraint definition of Umax");
        assert(max(rcdC.boundedUmax) <= m, "ERROR in constraint definition of Umax");
        assert(size(rcdC.boundedUmax,1) == size(rcdC.Umax,1), "ERROR in constraint definition of Umax");
      end if;
      assert(size(rcdC.boundedYmin,1) <= p, "ERROR in constraint definition of Ymin");
      if size(rcdC.boundedYmin,1) > 0 then
        assert(min(rcdC.boundedYmin) > 0, "ERROR in constraint definition of Ymin");
        assert(max(rcdC.boundedYmin) <= p, "ERROR in constraint definition of Ymin");
        assert(size(rcdC.boundedYmin,1) == size(rcdC.Ymin,1), "ERROR in constraint definition of Ymin");
      end if;
      assert(size(rcdC.boundedYmax,1) <= p, "ERROR in constraint definition of Ymax");
      if size(rcdC.boundedYmax,1) > 0 then
        assert(min(rcdC.boundedYmax) > 0, "ERROR in constraint definition of Ymax");
        assert(max(rcdC.boundedYmax) <= p, "ERROR in constraint definition of Ymax");
        assert(size(rcdC.boundedYmax,1) == size(rcdC.Ymax,1), "ERROR in constraint definition of Ymax");
      end if;
      assert(size(rcdC.boundedDeltaYmin,1) <= p, "ERROR in constraint definition of deltaYmin");
      if size(rcdC.boundedDeltaYmin,1) > 0 then
        assert(min(rcdC.boundedDeltaYmin) > 0, "ERROR in constraint definition of deltaYmin");
        assert(max(rcdC.boundedDeltaYmin) <= p, "ERROR in constraint definition of deltaYmin");
        assert(size(rcdC.boundedDeltaYmin,1) == size(rcdC.deltaYmin,1), "ERROR in constraints definition of deltaYmin");
      end if;
      assert(size(rcdC.boundedDeltaYmax,1) <= p, "ERROR in constraint definition of deltaYmax");
      if size(rcdC.boundedDeltaYmax,1) > 0 then
        assert(min(rcdC.boundedDeltaYmax) > 0, "ERROR in constraint definition of deltaYmax");
        assert(max(rcdC.boundedDeltaYmax) <= p, "ERROR in constraint definition of deltaYmax");
        assert(size(rcdC.boundedDeltaYmax,1) == size(rcdC.deltaYmax,1), "ERROR in constraints definition of deltaYmax");
      end if;

      // construct constraints matrix
      if rcdC.Nc == 0 then
        Ac := zeros(rcdC.Nc,m*Nu);
      else
        z := 1;

        // lower constraints on changes in u
        if size(rcdC.boundedDeltaUmin,1) > 0 then
          vec_H1min := Basic.expandBoundedX(rcdC.boundedDeltaUmin,Nu,m);
          mat_H1 :=-identity(m*Nu);
          Ac[z:z-1+size(vec_H1min,1),:] := mat_H1[vec_H1min,:];
          z := z + size(vec_H1min,1);
        end if;

        // upper constraints on changes in u
        if size(rcdC.boundedDeltaUmax,1) > 0 then
          vec_H1max := Basic.expandBoundedX(rcdC.boundedDeltaUmax,Nu,m);
          mat_H1 := identity(m*Nu);
          Ac[z:z-1+size(vec_H1max,1),:] := mat_H1[vec_H1max,:];
          z := z + size(vec_H1max,1);
        end if;

        // lower constraints on u
        if size(rcdC.boundedUmin,1) > 0 then
          vec_H2min := Basic.expandBoundedX(rcdC.boundedUmin,Nu,m);
          mat_H1 := zeros(m*Nu, m*Nu);
          for j in 1:Nu loop
            mat_H1[(j-1)*m+1:m*Nu,(j-1)*m+1:j*m] :=Basic.repmatIdentity1(m,Nu-j+1);
          end for;
          Ac[z:z-1+size(vec_H2min,1),:] := -1*mat_H1[vec_H2min,:];
          z := z + size(vec_H2min,1);
        end if;

        // upper constraints on u
        if size(rcdC.boundedUmax,1) > 0 then
          vec_H2max := Basic.expandBoundedX(rcdC.boundedUmax,Nu,m);
          mat_H1 := zeros(m*Nu, m*Nu);
          for j in 1:Nu loop
            mat_H1[(j-1)*m+1:m*Nu,(j-1)*m+1:j*m] := Basic.repmatIdentity1(m,Nu-j+1);
          end for;
          Ac[z:z-1+size(vec_H2max,1),:] := mat_H1[vec_H2max,:];
          z := z + size(vec_H2max,1);
        end if;

        // lower constraints on y
        if size(rcdC.boundedYmin,1) > 0 then
          Ac[z:z-1+size(rcdC.expBoundedYmin,1),:] := -1*P[rcdC.expBoundedYmin,:];
          z := z + size(rcdC.expBoundedYmin,1);
        end if;

        // upper constraints on y
        if size(rcdC.boundedYmax,1) > 0 then
          Ac[z:z-1+size(rcdC.expBoundedYmax,1),:] := 1*P[rcdC.expBoundedYmax,:];
          z := z + size(rcdC.expBoundedYmax,1);
        end if;

        // lower constraints on changes in y
        if size(rcdC.boundedDeltaYmin,1) > 0 then
        // construct P_quer
        mat_H2 := zeros((Np - Nl + 1)*p, m*Nu);
        for i in Nl:Np loop
           for j in Nl:min(Nl+Nu-1,Nl+i-1) loop
           if Nl+i-j <= Nm then
              if Nl+i-j-1 > 0 then
                 mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i-j,:,:] - S[Nl+i-j-1,:,:];
              elseif Nl+i-j-1 == 0 then
                 mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i-j,:,:];
              end if;
           else
           mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nm,:,:] - S[Nm-1,:,:];
           end if;
          end for;
        end for;
        Ac[z:z-1+size(rcdC.expBoundedDeltaYmin,1),:] := -mat_H2[rcdC.expBoundedDeltaYmin,:];
        z := z + size(rcdC.expBoundedDeltaYmin,1);
        end if;

        // upper constraints on changes in y
        if size(rcdC.boundedDeltaYmax,1) > 0 then
        // construct P_quer
        mat_H2 := zeros((Np - Nl + 1)*p, m*Nu);
        for i in Nl:Np loop
           for j in Nl:min(Nl+Nu-1,Nl+i-1) loop
           if Nl+i-j <= Nm then
              if Nl+i-j-1 > 0 then
                 mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i-j,:,:] - S[Nl+i-j-1,:,:];
              elseif Nl+i-j-1 == 0 then
                 mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i-j,:,:];
              end if;
           else
           mat_H2[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nm,:,:] - S[Nm-1,:,:];
           end if;
          end for;
        end for;
        Ac[z:z-1+size(rcdC.expBoundedDeltaYmax,1),:] := mat_H2[rcdC.expBoundedDeltaYmax,:];
        z := z + size(rcdC.expBoundedDeltaYmax,1);
        end if;

      end if;
    end ConstraintsMatrix;

    function calculateOutput
      input Real H[:,:] "Hessian matrix";
      input Real GhT[:,:];
      input Real F[:,:];
      input Real E[:,:];
      input Real[:,:,:] S "step response matrix";
      input Real Ac[:,:];
      input Real r[:] "reference trajectory";
      input Real y[:] "current values of controlled variables";
      input Real yPreMeasured[:]
        "measured controlled variables of last time step";
      input Real b[:] "prediction bias";
      input Real bpre[:] "prediction bias of last time step";
      input Real d[:] "measurable disturbances";
      input Real deltaUBuffer[:] "past values of delta_u";

      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nu "control horizon";
      input Integer Nm "model horizon";
      input Integer p "number of controlled variables";
      input Integer m "number of manipulated variables";
      input Integer Nc "number of constraints";

      input Basic.ConstraintsRecord rcdC;
      input Real u_pre[:] "last controller output u(k-1)";
      input Real deltaUpre[:] "last calculated trajectory";

      input Basic.QPSolverRecord SolverParams;

      output Real deltaU[m*Nu];

    protected
      Real G[m*Nu];

      Real bc[Nc];
      Integer Nhc "number of hard constraints";
      Real startValues[m*Nu] "start values of iteration";

      Integer h "auxiliary variable";
      constant Real H1[m,m] = identity(m) "auxiliary matrix";
      constant Real H2[p,p] = identity(p) "auxiliary matrix";
      Real H3[(Np-Nl+1)*p,(Nm-1)*m] = zeros((Np-Nl+1)*p,(Nm-1)*m)
        "matrix F_quer";

    algorithm
      // determine G
      G := GhT*(Basic.repmatIdentity1(m,(Np-Nl+1))*(y+b) + F*deltaUBuffer + E*d - r);

      if Nc > 0 then  // constrained case

        // construct constraints vector bc
        h := 1;
        // lower constraints on changes in u
        if size(rcdC.boundedDeltaUmin,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedDeltaUmin,1)] := -1*Basic.repVec(rcdC.deltaUmin,size(rcdC.deltaUmin,1),Nu);
        end if;
        h := h + Nu*size(rcdC.boundedDeltaUmin,1);
        // upper constraints on changes in u
        if size(rcdC.boundedDeltaUmax,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedDeltaUmax,1)] := Basic.repVec(rcdC.deltaUmax,size(rcdC.deltaUmax,1),Nu);
        end if;
        h := h + Nu*size(rcdC.boundedDeltaUmax,1);
        // lower constraints on u
        if size(rcdC.boundedUmin,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedUmin,1)] := -1*Basic.repVec(rcdC.Umin,size(rcdC.Umin,1),Nu) + Basic.repmat1(H1[rcdC.boundedUmin,:],size(rcdC.boundedUmin,1),m,Nu)*u_pre[rcdC.boundedUmin];
        end if;
        h := h + Nu*size(rcdC.boundedUmin,1);
        // upper constraints on u
        if size(rcdC.boundedUmax,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedUmax,1)] := Basic.repVec(rcdC.Umax,size(rcdC.Umax,1),Nu) - Basic.repmat1(H1[rcdC.boundedUmax,:],size(rcdC.boundedUmax,1),m,Nu)*u_pre[rcdC.boundedUmax];
        end if;
        h := h + Nu*size(rcdC.boundedUmax,1);
        Nhc := h - 1; // number of hard constraints
        // lower constraints on y
        if size(rcdC.boundedYmin,1) > 0 then
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedYmin,1)] := -1*Basic.repVec(rcdC.Ymin,size(rcdC.Ymin,1),Np-Nl+1) + Basic.repmat1(H2[rcdC.boundedYmin,:],size(rcdC.boundedYmin,1),p,Np-Nl+1)*(y+b) + F[rcdC.expBoundedYmin,:]*deltaUBuffer + E[rcdC.expBoundedYmin,:]*d;
        end if;
        h := h + Nu*size(rcdC.boundedYmin,1);
        // upper constraints on y
        if size(rcdC.boundedYmax,1) > 0 then
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedYmax,1)] := Basic.repVec(rcdC.Ymax,size(rcdC.Ymax,1),Np-Nl+1) - Basic.repmat1(H2[rcdC.boundedYmax,:],size(rcdC.boundedYmax,1),p,Np-Nl+1)*(y+b) - F[rcdC.expBoundedYmax,:]*deltaUBuffer -  E[rcdC.expBoundedYmax,:]*d;
        end if;
        h := h + Nu*size(rcdC.boundedYmax,1);

        // lower constraint on changes in y
        if size(rcdC.boundedDeltaYmin,1) > 0 then
        // construct F_quer
        H3 := zeros((Np - Nl + 1)*p, m*(Nm-1));
        for i in Nl:Np loop
           for j in Nl:Nl+Nm-2 loop
           if Nl+i+j-1 <= Nm then
             H3[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i+j-1,:,:] - S[Nl+i+j-2,:,:];
           else
           H3[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nm,:,:] - S[Nm-1,:,:];
           end if;
          end for;
        end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaYmin,1)] := -Basic.repVec(rcdC.deltaYmin,size(rcdC.deltaYmin,1),Np-Nl+1) + Basic.repmat1(H2[rcdC.boundedDeltaYmin,:],size(rcdC.boundedDeltaYmin,1),p,Np-Nl+1)*(y+b) - Basic.repmat1(H2[rcdC.boundedDeltaYmin,:],size(rcdC.boundedDeltaYmin,1),p,Np-Nl+1)*(yPreMeasured + bpre)  + H3[rcdC.expBoundedDeltaYmin,:]*deltaUBuffer -  E[rcdC.expBoundedDeltaYmin,:]*d;
        end if;
        h := h + Nu*size(rcdC.boundedDeltaYmin,1);

        // upper constraint on changes in y
        if size(rcdC.boundedDeltaYmax,1) > 0 then
        // construct F_quer
        H3 := zeros((Np - Nl + 1)*p, m*(Nm-1));
        for i in Nl:Np loop
           for j in Nl:Nl+Nm-2 loop
           if Nl+i+j-1 <= Nm then
             H3[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nl+i+j-1,:,:] - S[Nl+i+j-2,:,:];
           else
           H3[((i-Nl)*p+1):((i-Nl+1)*p),(j-Nl)*m+1:(j-Nl+1)*m] := S[Nm,:,:] - S[Nm-1,:,:];
           end if;
          end for;
        end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaYmax,1)] := +Basic.repVec(rcdC.deltaYmax,size(rcdC.deltaYmax,1),Np-Nl+1)  - Basic.repmat1(H2[rcdC.boundedDeltaYmax,:],size(rcdC.boundedDeltaYmax,1),p,Np-Nl+1)*(y+b)  + Basic.repmat1(H2[rcdC.boundedDeltaYmax,:],size(rcdC.boundedDeltaYmax,1),p,Np-Nl+1)*(yPreMeasured + bpre)  - H3[rcdC.expBoundedDeltaYmax,:]*deltaUBuffer +  E[rcdC.expBoundedDeltaYmax,:]*d;
        end if;
        h := h + Nu*size(rcdC.boundedDeltaYmax,1);

        // optimization call
        startValues := zeros(m*Nu);
        //startValues := cat(1,-1*deltaUBuffer[end-m+1:end],zeros(m*(Nu-1)));
        //startValues := cat(1,deltaUpre[m+1:end],-1*deltaUpre[end-m+1:end]);
        //startValues := cat(1,deltaUpre[m+1:end],zeros(m));
        deltaU := Solver.QPSolveSoft(H,G,Ac,bc,m*Nu,Nc,Nhc,startValues,SolverParams);
        //deltaU := Solver.QPSolve(H,G,Ac,bc,m*Nu,Nc,startValues);

      else  // unconstrained case

        deltaU := -Modelica.Math.Matrices.inv(H)*G;

      end if;

    end calculateOutput;

  end FunctionsStepResponse;

  package FunctionsStateSpace
    "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    function PredictionMatrix
      input Real[:,:] A "control system matrix A";
      input Real[:,:] B "control system matrix B";
      input Real[:,:] C "control system matrix C";
      input Real[:,:] D "control system matrix D";

      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nu "control horizon";

      input Integer m "number of control systems inputs";
      input Integer p "number of control systems outputs";

      output Real P[(Np-Nl+1)*p,Nu*m] "prediction matrix";

    algorithm
      for j in Nl:Np loop
        for i in 1:Nu loop
          if ((j-i) >= 0) then
            P[((j-1)*p+1):(j*p),((i-1)*m+1):(i*m)] := C*A^(j-i)*B;
          elseif ((j+1) == i) then
            P[((j-1)*p+1):(j*p),((i-1)*m+1):(i*m)] := D;
          else
            P[((j-1)*p+1):(j*p),((i-1)*m+1):(i*m)] := zeros(p, m);
          end if;
        end for;
      end for;

    end PredictionMatrix;

    function FreeResponseMatrix
      input Real[:,:] A "control system matrix A";
      input Real[:,:] C "control system matrix C";
      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";

      input Integer p "number of control systems outputs";

      output Real[(Np-Nl+1)*p,size(A,2)] F;

    algorithm
      for j in Nl:Np loop
        F[((j-1)*p+1):(j*p),:] := C*A^j;
      end for;

    end FreeResponseMatrix;

    function DisturbanceMatrix

      input Real[:,:] Ad;
      input Real A[:,:] "discrete time control system matrix A, inaugmented";
      input Real C[:,:] "discrete time control system matrix C, inaugmented";
      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer p "number of control systems outputs";
      input Integer q "number of measurable disturbance variables";

      output Real[p*(Np-Nl+1),q*(Np-Nl+1)] E;

    algorithm
       for j in Nl:Np loop
          for i in Nl:Np loop
           if j >= i then
           E[(j-1)*p+1:j*p, (i-1)*q+1:i*q]  := C*A^(j-i)*Ad;
                 else
                 E[(j-1)*p+1:j*p, (i-1)*q+1:i*q]  := zeros(p,q);
           end if;
          end for;
       end for;

    end DisturbanceMatrix;

    function ConstraintsMatrix

      input Basic.ConstraintsRecord rcdC;
      input Real[:,:] P "Prediction Matrix";

      input Integer p = 1 "number of controlled variables";
      input Integer m = 1 "number of manipulated variables";
      input Integer n = 1 "number of state variables";
      input Integer Nl = 1 "lower prediction horizon";
      input Integer Np = 1 "upper prediction horizon";
      input Integer Nu = 1 "control horizon";
      input Real A[:,:] "discrete time control system matrix A, inaugmented";
      input Real B[:,:] "discrete time control system matrix B, inaugmented";
      input Real C[:,:] "discrete time control system matrix C, inaugmented";
      input Real D[:,:] "discrete time control system matrix D, inaugmented";

      output Real[rcdC.Nc,m*Nu] Ac;

    protected
      Integer z "auxiliary variable";

      Integer[Nu*size(rcdC.boundedDeltaUmin, 1)] vec_H1min;
      Integer[Nu*size(rcdC.boundedDeltaUmax, 1)] vec_H1max;
      Integer[Nu*size(rcdC.boundedUmin, 1)] vec_H2min;
      Integer[Nu*size(rcdC.boundedUmax, 1)] vec_H2max;
      Real[m*Nu,m*Nu] mat_H1;

      Integer[(Np-Nl+1)*size(rcdC.boundedDeltaYmin, 1)] vec_H4min;
      Integer[(Np-Nl+1)*size(rcdC.boundedDeltaYmax, 1)] vec_H4max;
      Real[(Np-Nl+1)*n, Nu*m] mat_H5 = zeros((Np-Nl+1)*n, Nu*m)
        "Hilfsmatrix Theta";
      Real[(Np-Nl+1)*p,m*Nu] mat_H2 "Hilfsmatrix Theta";
      Real[n,m] q = zeros(n,m) "Hilfsmatrix f�r Reihe";

    algorithm
    // check for correct array dimensions and indices
      assert(size(rcdC.boundedDeltaUmin,1) <= m, "ERROR in constraint definition of deltaUmin");
      if size(rcdC.boundedDeltaUmin,1) > 0 then
        assert(min(rcdC.boundedDeltaUmin) > 0, "ERROR in constraint definition of deltaUmin");
        assert(max(rcdC.boundedDeltaUmin) <= m, "ERROR in constraint definition of deltaUmin");
        assert(size(rcdC.boundedDeltaUmin,1) == size(rcdC.deltaUmin,1), "ERROR in constraint definition of deltaUmin");
      end if;
      assert(size(rcdC.boundedDeltaUmax,1) <= m, "ERROR in constraint definition of deltaUmax");
      if size(rcdC.boundedDeltaUmax,1) > 0 then
        assert(min(rcdC.boundedDeltaUmax) > 0, "ERROR in constraint definition of deltaUmax");
        assert(max(rcdC.boundedDeltaUmax) <= m, "ERROR in constraint definition of deltaUmax");
        assert(size(rcdC.boundedDeltaUmax,1) == size(rcdC.deltaUmax,1), "ERROR in constraint definition of deltaUmax");
      end if;
      assert(size(rcdC.boundedUmin,1) <= m, "ERROR in constraint definition of Umin");
      if size(rcdC.boundedUmin,1) > 0 then
        assert(min(rcdC.boundedUmin) > 0, "ERROR in constraint definition of Umin");
        assert(max(rcdC.boundedUmin) <= m, "ERROR in constraint definition of Umin");
        assert(size(rcdC.boundedUmin,1) == size(rcdC.Umin,1), "ERROR in constraint definition of Umin");
      end if;
      assert(size(rcdC.boundedUmax,1) <= m, "ERROR in constraint definition of Umax");
      if size(rcdC.boundedUmax,1) > 0 then
        assert(min(rcdC.boundedUmax) > 0, "ERROR in constraint definition of Umax");
        assert(max(rcdC.boundedUmax) <= m, "ERROR in constraint definition of Umax");
        assert(size(rcdC.boundedUmax,1) == size(rcdC.Umax,1), "ERROR in constraint definition of Umax");
      end if;
      assert(size(rcdC.boundedYmin,1) <= p, "ERROR in constraint definition of Ymin");
      if size(rcdC.boundedYmin,1) > 0 then
        assert(min(rcdC.boundedYmin) > 0, "ERROR in constraint definition of Ymin");
        assert(max(rcdC.boundedYmin) <= p, "ERROR in constraint definition of Ymin");
        assert(size(rcdC.boundedYmin,1) == size(rcdC.Ymin,1), "ERROR in constraint definition of Ymin");
      end if;
      assert(size(rcdC.boundedYmax,1) <= p, "ERROR in constraint definition of Ymax");
      if size(rcdC.boundedYmax,1) > 0 then
        assert(min(rcdC.boundedYmax) > 0, "ERROR in constraint definition of Ymax");
        assert(max(rcdC.boundedYmax) <= p, "ERROR in constraint definition of Ymax");
        assert(size(rcdC.boundedYmax,1) == size(rcdC.Ymax,1), "ERROR in constraint definition of Ymax");
      end if;
      assert(size(rcdC.boundedDeltaYmin,1) <= p, "ERROR in constraint definition of deltaYmin");
      if size(rcdC.boundedDeltaYmin,1) > 0 then
        assert(min(rcdC.boundedDeltaYmin) > 0, "ERROR in constraint definition of deltaYmin");
        assert(max(rcdC.boundedDeltaYmin) <= p, "ERROR in constraint definition of deltaYmin");
        assert(size(rcdC.boundedDeltaYmin,1) == size(rcdC.deltaYmin,1), "ERROR in constraints definition of deltaYmin");
      end if;
      assert(size(rcdC.boundedDeltaYmax,1) <= p, "ERROR in constraint definition of deltaYmax");
      if size(rcdC.boundedDeltaYmax,1) > 0 then
        assert(min(rcdC.boundedDeltaYmax) > 0, "ERROR in constraint definition of deltaYmax");
        assert(max(rcdC.boundedDeltaYmax) <= p, "ERROR in constraint definition of deltaYmax");
        assert(size(rcdC.boundedDeltaYmax,1) == size(rcdC.deltaYmax,1), "ERROR in constraints definition of deltaYmax");
      end if;

      assert(size(rcdC.boundedXmin,1) <= n, "ERROR in constraint definition of Xmin");
      if size(rcdC.boundedXmin,1) > 0 then
        assert(min(rcdC.boundedXmin) > 0, "ERROR in constraint definition of Xmin");
        assert(max(rcdC.boundedXmin) <= n, "ERROR in constraint definition of Xmin");
        assert(size(rcdC.boundedXmin,1) == size(rcdC.Xmin,1), "ERROR in constraint definition of Xmin");
      end if;
      assert(size(rcdC.boundedXmax,1) <= n, "ERROR in constraint definition of Xmax");
      if size(rcdC.boundedXmax,1) > 0 then
        assert(min(rcdC.boundedXmax) > 0, "ERROR in constraint definition of Xmax");
        assert(max(rcdC.boundedXmax) <= n, "ERROR in constraint definition of Xmax");
        assert(size(rcdC.boundedXmax,1) == size(rcdC.Xmax,1), "ERROR in constraint definition of Xmax");
      end if;
      assert(size(rcdC.boundedDeltaXmin,1) <= n, "ERROR in constraint definition of deltaXmin");   // wieviele x, m!?
      if size(rcdC.boundedDeltaXmin,1) > 0 then
        assert(min(rcdC.boundedDeltaXmin) > 0, "ERROR in constraint definition of deltaXmin");
        assert(max(rcdC.boundedDeltaXmin) <= n, "ERROR in constraint definition of deltaXmin");
        assert(size(rcdC.boundedDeltaXmin,1) == size(rcdC.deltaXmin,1), "ERROR in constraints definition of deltaXmin");
      end if;
      assert(size(rcdC.boundedDeltaXmax,1) <= n, "ERROR in constraint definition of deltaXmax");
      if size(rcdC.boundedDeltaXmax,1) > 0 then
        assert(min(rcdC.boundedDeltaXmax) > 0, "ERROR in constraint definition of deltaXmax");
        assert(max(rcdC.boundedDeltaXmax) <= n, "ERROR in constraint definition of deltaXmax");
        assert(size(rcdC.boundedDeltaXmax,1) == size(rcdC.deltaXmax,1), "ERROR in constraints definition of deltaXmax");
      end if;

      // construct constraints matrix
      if rcdC.Nc == 0 then
        Ac := zeros(rcdC.Nc,m*Nu);
      else
        z := 1;

        // lower constraints on changes in u
        if size(rcdC.boundedDeltaUmin,1) > 0 then
          vec_H1min := Basic.expandBoundedX(rcdC.boundedDeltaUmin,Nu,m);
          mat_H1 :=-identity(m*Nu);
          Ac[z:z-1+size(vec_H1min,1),:] := mat_H1[vec_H1min,:];
          z := z + size(vec_H1min,1);
        end if;

        // upper constraints on changes in u
        if size(rcdC.boundedDeltaUmax,1) > 0 then
          vec_H1max := Basic.expandBoundedX(rcdC.boundedDeltaUmax,Nu,m);
          mat_H1 := identity(m*Nu);
          Ac[z:z-1+size(vec_H1max,1),:] := mat_H1[vec_H1max,:];
          z := z + size(vec_H1max,1);
        end if;

        // lower constraints on u
        if size(rcdC.boundedUmin,1) > 0 then
          vec_H2min := Basic.expandBoundedX(rcdC.boundedUmin,Nu,m);
          mat_H1 := zeros(m*Nu, m*Nu);
          for j in 1:Nu loop
            mat_H1[(j-1)*m+1:m*Nu,(j-1)*m+1:j*m] :=Basic.repmatIdentity1(m,Nu-j+1);
          end for;
          Ac[z:z-1+size(vec_H2min,1),:] := -1*mat_H1[vec_H2min,:];
          z := z + size(vec_H2min,1);
        end if;

        // upper constraints on u
        if size(rcdC.boundedUmax,1) > 0 then
          vec_H2max := Basic.expandBoundedX(rcdC.boundedUmax,Nu,m);
          mat_H1 := zeros(m*Nu, m*Nu);
          for j in 1:Nu loop
            mat_H1[(j-1)*m+1:m*Nu,(j-1)*m+1:j*m] := Basic.repmatIdentity1(m,Nu-j+1);
          end for;
          Ac[z:z-1+size(vec_H2max,1),:] := mat_H1[vec_H2max,:];
          z := z + size(vec_H2max,1);
        end if;

        // lower constraints on y
        if size(rcdC.boundedYmin,1) > 0 then
          Ac[z:z-1+size(rcdC.expBoundedYmin,1),:] := -1*P[rcdC.expBoundedYmin,:];
          z := z + size(rcdC.expBoundedYmin,1);
        end if;

        // upper constraints on y
        if size(rcdC.boundedYmax,1) > 0 then
          Ac[z:z-1+size(rcdC.expBoundedYmax,1),:] := 1*P[rcdC.expBoundedYmax,:];
          z := z + size(rcdC.expBoundedYmax,1);
        end if;

        // lower constraints on changes in y
        if size(rcdC.boundedDeltaYmin,1) > 0 then
        //Theta
          for j in Nl:Np loop
            for i in 1:Nu loop
              if (j-i) >= 0 then
                mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := C*A^(j-i)*B;
              else if j-i == -1 then
                mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := D;
                 else
                   mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := zeros(p,m);
                 end if;
                end if;
              end for;
            end for;
          Ac[z:z-1+size(rcdC.expBoundedDeltaYmin,1),:] := -1*mat_H2[rcdC.expBoundedDeltaYmin,:];
         z := z + size(rcdC.expBoundedDeltaYmin,1);
        end if;

        // upper constraints on changes in y
        if size(rcdC.boundedDeltaYmax,1) > 0 then
        //Theta
          for j in Nl:Np loop
            for i in 1:Nu loop
              if (j-i) >= 0 then
                mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := C*A^(j-i)*B;
              else if j-i == -1 then
                mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := D;
                 else
                   mat_H2[(j-1)*p+1:j*p,(i-1)*m+1:i*m] := zeros(p,m);
                 end if;
                end if;
              end for;
            end for;
        Ac[z:z-1+size(rcdC.expBoundedDeltaYmax,1),:] := 1*mat_H2[rcdC.expBoundedDeltaYmax,:];
         z := z + size(rcdC.expBoundedDeltaYmax,1);
        end if;

        // lower constraints on x
        if size(rcdC.boundedXmin,1) > 0 then
        //  Matrix Theta:
          for j in Nl:Np loop
            for i in 1:Nu loop
              q := zeros(n,m);                  // reset q
              if ((j-i) >= 0) then
                   for r in 1:(j-i+1) loop
                    q := q + A^(r-1)*B;
                   end for;
                  mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := q;      // hier muss er bei [1,:] anfangen, noch �ndern, da Nl = 1 geht es hier auch so
              else
                mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := zeros(n, m);
              end if;
            end for;
          end for;
          Ac[z:z-1+size(rcdC.expBoundedXmin,1),:] := -1*mat_H5[rcdC.expBoundedXmin,:];
          z := z + size(rcdC.expBoundedXmin,1);
        end if;

        // upper constraints on x
        if size(rcdC.boundedXmax,1) > 0 then
        //  Matrix Theta:
          for j in Nl:Np loop
            for i in 1:Nu loop
             q := zeros(n,m);                  // reset q
              if ((j-i) >= 0) then
                   for r in 1:(j-i+1) loop
                    q := q + A^(r-1)*B;
                   end for;
                mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := q;
              else
                mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := zeros(n, m);
              end if;
            end for;
          end for;
          Ac[z:z-1+size(rcdC.expBoundedXmax,1),:] := 1*mat_H5[rcdC.expBoundedXmax,:];
          z := z + size(rcdC.expBoundedXmax,1);
        end if;

        // lower constraints on changes in x
        if size(rcdC.boundedDeltaXmin,1) > 0 then
        //  Matrix Theta:
          for j in Nl:Np loop
            for i in 1:Nu loop
              if ((j-i) >= 0) then
                mat_H5[((j-1)*n+1):(j*n),(i-1)*m+1:i*m] := A^(j-i)*B;
              else
                mat_H5[((j-1)*n+1):(j*n),(i-1)*m+1:i*m] := zeros(n, m);
              end if;
            end for;
          end for;
          Ac[z:z-1+size(rcdC.expBoundedDeltaXmin,1),:] := -1*mat_H5[rcdC.expBoundedDeltaXmin,:];
          z := z + size(rcdC.expBoundedDeltaXmin,1);
        end if;

        // upper constraints on changes in x
        if size(rcdC.boundedDeltaXmax,1) > 0 then
        //  Matrix Theta:
          for j in Nl:Np loop
            for i in 1:Nu loop
              if ((j-i) >= 0) then
                mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := A^(j-i)*B;
              else
                mat_H5[((j-1)*n+1):(j*n),((i-1)*m+1):(i*m)] := zeros(n, m);
              end if;
            end for;
          end for;
          Ac[z:z-1+size(rcdC.expBoundedDeltaXmax,1),:] := 1*mat_H5[rcdC.expBoundedDeltaXmax,:];
          z := z + size(rcdC.expBoundedDeltaXmax,1);
        end if;

      end if;

    end ConstraintsMatrix;

    function calculateOutput
      input Real H[:,:] "Hessian matrix";
      input Real GhT[:,:];
      input Real A[:,:] "discrete time control system matrix A, inaugmented";
      input Real B[:,:] "discrete time control system matrix B, inaugmented";
      input Real C[:,:] "discrete time control system matrix C, inaugmented";
      input Real D[:,:] "discrete time control system matrix D, inaugmented";
      input Real F[:,:];
      input Real E[:,:];
      input Real Ac[:,:];

      input Real r[:] "reference trajectory";
      // input Real b[:] "prediction bias";
      input Real x[:] "current values of state variables, augmented";
      // input Real x_pre[n] "last state x(k-1) of inaugmented statevector";
      input Real u_pre[:] "last controller output u(k-1)";
      // input Real y_pre[:] "last manipulated variable output y(k-1)";
      // input Real y[:] "manipulated variable output";
      input Real d[:] "measurable disturbances";

      input Integer Nl "lower prediction horizon";
      input Integer Np "upper prediction horizon";
      input Integer Nu "control horizon";
      input Integer p "number of controlled variables";
      input Integer m "number of manipulated variables";
      input Integer n "number of state variables";

      input Basic.ConstraintsRecord rcdC;
      input Basic.QPSolverRecord SolverParams;

      output Real deltaU[m*Nu];

    protected
      Real G[m*Nu];

      Real bc[rcdC.Nc];
      Integer Nhc "number of hard constraints";
      Real startValues[m*Nu] "start values of iteration";

      Integer h "auxiliary variable";
      constant Real H1[m,m] = identity(m) "auxiliary matrix";
      constant Real H2[p,p] = identity(p) "auxiliary matrix";
      constant Real H3[n,n] = identity(n) "auxiliary matrix";
      Real deltaX[n] "changes in x";
      Real q[n,m] = zeros(n,m) "Hilfsmatrix f�r Reihe";
      Real Phi[(Np-Nl+1)*n,m+n] "Phi";
      Real mat_H1[(Np-Nl+1)*p,m+n] "Phi";

    algorithm
      // determine G
      G := GhT*(F*x + E*d - r);

      if rcdC.Nc > 0 then  // constrained case

        // construct constraints vector bc
        h := 1;
        // lower constraints on changes in u
        if size(rcdC.boundedDeltaUmin,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedDeltaUmin,1)] := -1*Basic.repVec(rcdC.deltaUmin,size(rcdC.deltaUmin,1),Nu);
        end if;
        h := h + Nu*size(rcdC.boundedDeltaUmin,1);
        // upper constraints on changes in u
        if size(rcdC.boundedDeltaUmax,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedDeltaUmax,1)] := Basic.repVec(rcdC.deltaUmax,size(rcdC.deltaUmax,1),Nu);
        end if;
        h := h + Nu*size(rcdC.boundedDeltaUmax,1);
        // lower constraints on u
        if size(rcdC.boundedUmin,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedUmin,1)] := -1*Basic.repVec(rcdC.Umin,size(rcdC.Umin,1),Nu) + Basic.repmat1(H1[rcdC.boundedUmin,:],size(rcdC.boundedUmin,1),m,Nu)*u_pre[:];
        end if;
        h := h + Nu*size(rcdC.boundedUmin,1);
        // upper constraints on u
        if size(rcdC.boundedUmax,1) > 0 then
          bc[h:h-1+Nu*size(rcdC.boundedUmax,1)] := Basic.repVec(rcdC.Umax,size(rcdC.Umax,1),Nu) - Basic.repmat1(H1[rcdC.boundedUmax,:],size(rcdC.boundedUmax,1),m,Nu)*u_pre[:];
        end if;
        h := h + Nu*size(rcdC.boundedUmax,1);
        Nhc := h - 1; //number of hard constraints
        // lower constraints on y
        if size(rcdC.boundedYmin,1) > 0 then
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedYmin,1)] := -1*Basic.repVec(rcdC.Ymin,size(rcdC.Ymin,1),Np-Nl+1) + F[rcdC.expBoundedYmin,:]*x + E[rcdC.expBoundedYmin,:]*d;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedYmin,1);
        // upper constraints on y
        if size(rcdC.boundedYmax,1) > 0 then
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedYmax,1)] := Basic.repVec(rcdC.Ymax,size(rcdC.Ymax,1),Np-Nl+1) - F[rcdC.expBoundedYmax,:]*x - E[rcdC.expBoundedYmax,:]*d;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedYmax,1);

        // lower constraint on changes in y
        if size(rcdC.boundedDeltaYmin,1) > 0 then
        // Matrix Phi:
           for j in Nl:Np loop
           mat_H1[((j-1)*p+1):(j*p),1:n] := C*(A-identity(n))*A^(j-1);
           mat_H1[((j-1)*p+1):(j*p),n+1:n+m] := C*A^(j-1)*B;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaYmin,1)] := - 1*Basic.repVec(rcdC.deltaYmin,size(rcdC.deltaYmin,1),Np-Nl+1) + mat_H1[rcdC.expBoundedDeltaYmin,:]*x + E[rcdC.expBoundedDeltaYmin,:]*d;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedDeltaYmin,1);

        // upper constraints on changes in y
        if size(rcdC.boundedDeltaYmax,1) > 0 then
        // Matrix Phi:
           for j in Nl:Np loop
           mat_H1[((j-1)*p+1):(j*p),1:n] := C*(A-identity(n))*A^(j-1);
           mat_H1[((j-1)*p+1):(j*p),n+1:n+m] := C*A^(j-1)*B;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaYmax,1)] :=  1*Basic.repVec(rcdC.deltaYmax,size(rcdC.deltaYmax,1),Np-Nl+1) - mat_H1[rcdC.expBoundedDeltaYmax,:]*x - E[rcdC.expBoundedDeltaYmax,:]*d;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedDeltaYmax,1);

        // lower constraint in x
        if size(rcdC.boundedXmin,1) > 0 then
        // Matrix Phi:
           for j in Nl:Np loop
           Phi[((j-1)*n+1):(j*n),1:n] := A^j;
               q := zeros(n,m);                  // reset q
                for r in 1:j loop
                  q := q + A^(j-1)*B;
                end for;
              Phi[(j-1)*n+1:j*n,n+1:n+m] := q;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedXmin,1)] := -1*Basic.repVec(rcdC.Xmin,size(rcdC.Xmin,1),Np-Nl+1)  + Phi[rcdC.expBoundedXmin,:]*x;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedXmin,1);

        // upper constraint in x
        if size(rcdC.boundedXmax,1) > 0 then
        // Matrix Phi:
         for j in Nl:Np loop
           Phi[((j-1)*n+1):(j*n),1:n] := A^j;
               q := zeros(n,m);                  // reset q
                for r in 1:j loop
                  q := q + A^(j-1)*B;
                end for;
                  Phi[(j-1)*n+1:j*n,n+1:n+m] := q;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedXmax,1)] := 1*Basic.repVec(rcdC.Xmax,size(rcdC.Xmax,1),Np-Nl+1)  - Phi[rcdC.expBoundedXmax,:]*x;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedXmax,1);

        // lower constraint on changes in x
        if size(rcdC.boundedDeltaXmin,1) > 0 then
        // Vector Phi:
          for j in Nl:Np loop
           Phi[((j-1)*n+1):(j*n),1:n] := (A-identity(n))*A^(j-1);
              Phi[((j-1)*n+1):(j*n),n+1:n+m] := A^(j-1)*B;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaXmin,1)] :=  -1*Basic.repVec(rcdC.deltaXmin,size(rcdC.deltaXmin,1),Np-Nl+1)  + Phi[rcdC.expBoundedDeltaXmin,:]*x;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedDeltaXmin,1);

        // upper constraint on changes in x
        if size(rcdC.boundedDeltaXmax,1) > 0 then
        // Vector Phi:
          for j in Nl:Np loop
           Phi[((j-1)*n+1):(j*n),1:n] := (A-identity(n))*A^(j-1);
              Phi[((j-1)*n+1):(j*n),n+1:n+m] := A^(j-1)*B;
          end for;
          bc[h:h-1+(Np-Nl+1)*size(rcdC.boundedDeltaXmax,1)] := 1*Basic.repVec(rcdC.deltaXmax,size(rcdC.deltaXmax,1),Np-Nl+1)  - Phi[rcdC.expBoundedDeltaXmax,:]*x;
        end if;
        h := h + (Np-Nl+1)*size(rcdC.boundedDeltaXmin,1);

        // optimization call
        startValues := zeros(m*Nu);
        deltaU := Solver.QPSolveSoft(H,G,Ac,bc,m*Nu,rcdC.Nc,Nhc,startValues,SolverParams);

      else  // unconstrained case

        //deltaU := -Modelica.Math.Matrices.inv(H)*G;
        deltaU := Modelica.Math.Matrices.solve(H,-G);

      end if;

    end calculateOutput;

  end FunctionsStateSpace;

  model MPCstepresponse
    "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    extends Basic.linMPCpartial(redeclare replaceable parameter ModelType
        modelType = Basic.step_response_model);

  // model parameters
    // step response description
    parameter Integer Nm(min = 2) = 2 "model horizon"
                                     annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    parameter Real[:,p,m] S = zeros(Nm,p,m) "step response matrix"
                                               annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    // disturbance model
    parameter Integer Nmd = 2 "model horizon of measurable disturbances"
                                                   annotation(Dialog(enable=(q>0), tab="Model parameters", group="disturbance model"));
    parameter Real[Nmd,p,q] Sd = zeros(Nmd,p,q)
      "step response matrix of measurable disturbances"
                                               annotation(Dialog(enable=(q>0), tab="Model parameters", group="disturbance model"));

  protected
    parameter Real P[:,:] = FunctionsStepResponse.PredictionMatrix(S,Nl,Np,Nu,Nm,m,p);
    parameter Real F[:,:] = FunctionsStepResponse.FreeResponseMatrix(S,Nl,Np,Nm,m,p);
    parameter Real E[:,:] = FunctionsStepResponse.DisturbanceMatrix(Sd,Nl,Np,Nmd,p,q);
    parameter Real H[m*Nu,m*Nu] = 2*(transpose(P)*Qexp*P + Rexp);
    parameter Real GhT[:,:] = transpose(2*Qexp*P);
  //constraints
    parameter Integer Nc = constraints*(Nu*(size(boundedDeltaUmin,1)+size(boundedDeltaUmax,1)+size(boundedUmin,1)+size(boundedUmax,1))+(Np-Nl+1)*(size(boundedYmin,1)+size(boundedYmax,1)+size(boundedDeltaYmin,1)+size(boundedDeltaYmax,1)))
      "number of constraints";
    parameter Basic.ConstraintsRecord rcdConstraints(Nc=Nc,boundedDeltaUmin=boundedDeltaUmin,deltaUmin=deltaUmin,boundedDeltaUmax=boundedDeltaUmax,deltaUmax=deltaUmax,boundedUmin=boundedUmin,Umin=Umin,boundedUmax=boundedUmax,Umax=Umax,boundedYmin=boundedYmin,Ymin=Ymin,boundedYmax=boundedYmax,Ymax=Ymax,boundedDeltaYmin=boundedDeltaYmin,deltaYmin=deltaYmin,boundedDeltaYmax=boundedDeltaYmax,deltaYmax=deltaYmax,expBoundedYmin=Basic.expandBoundedX(boundedYmin,Np-Nl+1,p),expBoundedYmax=Basic.expandBoundedX(boundedYmax,Np-Nl+1,p),expBoundedDeltaYmin=Basic.expandBoundedX(boundedDeltaYmin,Np-Nl+1,p),expBoundedDeltaYmax=Basic.expandBoundedX(boundedDeltaYmax,Np-Nl+1,p));
    parameter Real[:,:] Ac = FunctionsStepResponse.ConstraintsMatrix(rcdConstraints,P,S,p,m,Nl,Np,Nu,Nm)
      "matrix of constraints (Ac*deltaU <= bc)";

    discrete Real deltaUBuffer[m*(Nm-1)]
      "buffer of past changes of manipulated variables";
    discrete Real deltaDBuffer[q*(Nmd)]
      "buffer of past changes of disturbance variables";
    discrete Real disturbance[q*(Nmd-1+Np)]
      "vector of past and prospective changes of measurable disturbance variables";

    discrete Real yPreNext[p];  // prediction of y for the following discrete time step without bias compensation
    discrete Real yPreNextBias[p];  // prediction of y for the following discrete time step with bias compensation
  public
    discrete Real yPre[p];  // prediction of y for the current discrete time step made in the previous discrete time step without bias compensation
    discrete Real yPreBias[p];  // prediction of y for the current discrete time step made in the previous discrete time step with bias compensation
    discrete Real b[p] "prediction bias";
    discrete Real bpre[p];
    discrete Real ypre_measured[p];
    discrete Real ypre_measured2[p];
    discrete Real deltaY[p];

    Modelica.Blocks.Interfaces.RealInput y[p]
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
            rotation=0)));

  initial equation
    deltaUBuffer = zeros(m*(Nm-1));
    deltaDBuffer = zeros(q*(Nmd));
    disturbance = zeros(q*(Nmd-1+Np));
    yPreNext = zeros(p);
    yPre = zeros(p);
    bpre = zeros(p);
    ypre_measured = zeros(p);
    ypre_measured2 = zeros(p);
    deltaY = zeros(p);

  equation
    when sample(0, Ts) then

      // buffer past changes in u
      deltaUBuffer = Basic.MoveBuffer(pre(deltaUBuffer),pre(deltaUk),m,(Nm-1)*m);

      // measureable disturbances
      if q > 0 then
        deltaDBuffer = Basic.MoveBuffer(pre(deltaDBuffer),d[1:q],q,Nmd);
        disturbance[1:q*(Nmd)] = deltaDBuffer;
        if DisturbanceInput == 0 then // input is current measurement only
          //disturbance[q*(Nmd-1)+1:q*Nmd] = d;
          disturbance[q*Nmd+1:end] = zeros(q*(Np-1));  // <<< --------------------- ???
        else // input is enitre prospective trajectory
          disturbance[q*Nmd+1:end] = d[q+1:end];
        end if;
      else
        disturbance = zeros(q*(Nmd-1+Np));
      end if;

      // prediction bias
      b = biasCompensation*(y-yPre);
      bpre = pre(b) "prediction bias of last time step";
      ypre_measured = pre(y);
      ypre_measured2 = pre(ypre_measured)
        "measured control value of last time step, y(k-1)";
      deltaY = y - ypre_measured2
        "difference between control values of last and current time step";

      deltaU = FunctionsStepResponse.calculateOutput(H,GhT,F,E,S,Ac,r,y,ypre_measured2,b,bpre,disturbance,deltaUBuffer,Nl,Np,Nu,Nm,p,m,Nc,rcdConstraints,unitDelay.y,pre(deltaU),SolverParams);

      // prediction of y for the following discrete time step
      yPreNext = y + F[1:p,:]*deltaUBuffer + E[1:p,:]*disturbance + S[1,:,:]*deltaUk; // without bias compensation
      yPreNextBias = yPreNext + b; // with bias compensation
      // prediction of y for the current discrete time step made in the previous discrete time step
      yPre = pre(yPreNext); // without bias compensation
      yPreBias = pre(yPreNextBias); // with bias compensation
    end when;

    annotation (Diagram(graphics),
                         Icon(graphics={Rectangle(
            extent={{-2,-34},{80,-66}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Line(
            points={{8,-60},{28,-60},{28,-42},{68,-42}},
            color={0,0,0},
            thickness=1)}));
  end MPCstepresponse;

  block MPCstatespace
    "Modelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    extends Basic.linMPCpartial(redeclare replaceable parameter Type ModelType=
                    Basic.state_space_model);

    Modelica.Blocks.Interfaces.RealInput x[n]
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
            rotation=0)));

  // model parameters
    parameter Integer n = 1 "number of state variables"
                                                       annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));

    // state space description
    parameter Real[:,:] A = zeros(n,n) "discrete time control system matrix A" annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    parameter Real[:,:] B = zeros(n,m) "discrete time control system matrix B" annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    parameter Real[:,:] C = zeros(p,n) "discrete time control system matrix C" annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    parameter Real[:,:] D = zeros(p,m) "discrete time control system matrix D" annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));
    parameter Real[n,q] Ads = zeros(n,q)
      "impact of measurable disturbances on state variables" annotation(Dialog(enable=true, tab="Model parameters", group="model parameters"));

  // constraints on state variables
    parameter Integer[:] boundedXmin = zeros(0)
      "vector of indices of lower bounded variables"
                                                 annotation(Dialog(enable=(constraints==1), tab="Constraints", group="state variables"));
    parameter Real[:] Xmin = -1*ones(0) "vector of lower bounds"
                                          annotation(Dialog(enable=(size(boundedXmin,1)>0) and (constraints==1), tab="Constraints", group="state variables"));
    parameter Integer[:] boundedXmax = zeros(0)
      "vector of indices of upper bounded variables"
                                                 annotation(Dialog(enable=(constraints==1), tab="Constraints", group="state variables"));
    parameter Real[:] Xmax = 1*ones(0) "vector of upper bounds"
                                           annotation(Dialog(enable=(size(boundedXmax,1)>0) and (constraints==1), tab="Constraints", group="state variables"));
    parameter Integer[:] boundedDeltaXmin = zeros(0)
      "vector of indices of lower bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in state variables"));
    parameter Real[:] deltaXmin = -1*ones(0) "vector of lower bounds"
                                               annotation(Dialog(enable=(size(boundedDeltaXmin,1)>0) and (constraints==1), tab="Constraints", group="changes in state variables"));
    parameter Integer[:] boundedDeltaXmax = zeros(0)
      "vector of indices of upper bounded variables"  annotation(Dialog(enable=(constraints==1), tab="Constraints", group="changes in state variables"));
    parameter Real[:] deltaXmax = 1*ones(0) "vector of upper bounds"
                                                annotation(Dialog(enable=(size(boundedDeltaXmax,1)>0) and (constraints==1), tab="Constraints", group="changes in state variables"));

    // discrete Real x_pre[n];
    // discrete Real yPre[p];  // prediction of y for the current discrete time step made in the previous discrete time step without bias compensation
    // discrete Real yPreBias[p];  // prediction of y for the current discrete time step made in the previous discrete time step with bias compensation
    discrete Real b[p] "prediction bias";
    discrete Real y_est[p];
    discrete Real deltaY[p];
    //discrete Real yPreNext[p];  // prediction of y for the following discrete time step without bias compensation
    //discrete Real yPreNextBias[p];  // prediction of y for the following discrete time step with bias compensation

    // adding integral behaviour to the system model

  protected
    parameter Real AI[:,:] = cat(1,cat(2,A,B),cat(2,zeros(m,n), identity(m)));
    parameter Real BI[:,:] = cat(1,B,identity(m));
    parameter Real CI[:,:] = cat(2,C,D);

    parameter Real P[:,:] = FunctionsStateSpace.PredictionMatrix(AI,BI,CI,D,Nl,Np,Nu,m,p);
    parameter Real F[:,:] = FunctionsStateSpace.FreeResponseMatrix(AI,CI,Nl,Np,p);
    parameter Real E[:,:] = FunctionsStateSpace.DisturbanceMatrix(Ads,A,C,Nl,Np,p,q);
    parameter Real H[m*Nu,m*Nu] = 2*(transpose(P)*Qexp*P + Rexp);
    parameter Real GhT[:,:] = transpose(2*Qexp*P);
    discrete Real disturbance[q*(Np-Nl+1)];

  // constraints
    parameter Integer Nc = constraints*(Nu*(size(boundedDeltaUmin,1)+size(boundedDeltaUmax,1)+size(boundedUmin,1)+size(boundedUmax,1))+(Np-Nl+1)*(size(boundedYmin,1)+size(boundedYmax,1)+size(boundedDeltaYmin,1)+size(boundedDeltaYmax,1) + size(boundedXmin,1)+size(boundedXmax,1)+size(boundedDeltaXmin,1)+size(boundedDeltaXmax,1)))
      "number of constraints";
    parameter Basic.ConstraintsRecord rcdConstraints(Nc=Nc,boundedDeltaUmin=boundedDeltaUmin,deltaUmin=deltaUmin,boundedDeltaUmax=boundedDeltaUmax,deltaUmax=deltaUmax,boundedUmin=boundedUmin,Umin=Umin,boundedUmax=boundedUmax,Umax=Umax,boundedYmin=boundedYmin,Ymin=Ymin,boundedYmax=boundedYmax,Ymax=Ymax,boundedDeltaYmin=boundedDeltaYmin,deltaYmin=deltaYmin,boundedDeltaYmax=boundedDeltaYmax,deltaYmax=deltaYmax,boundedXmin=boundedXmin,Xmin=Xmin,boundedXmax=boundedXmax,Xmax=Xmax,boundedDeltaXmin=boundedDeltaXmin,deltaXmin=deltaXmin,boundedDeltaXmax=boundedDeltaXmax,deltaXmax=deltaXmax,expBoundedYmin=Basic.expandBoundedX(boundedYmin,Np-Nl+1,p),expBoundedYmax=Basic.expandBoundedX(boundedYmax,Np-Nl+1,p),expBoundedXmin=Basic.expandBoundedX(boundedXmin,Np-Nl+1,n),expBoundedXmax=Basic.expandBoundedX(boundedXmax,Np-Nl+1,n),expBoundedDeltaXmin=Basic.expandBoundedX(boundedDeltaXmin,Np-Nl+1,n),expBoundedDeltaXmax=Basic.expandBoundedX(boundedDeltaXmax,Np-Nl+1,n),expBoundedDeltaYmin=Basic.expandBoundedX(boundedDeltaYmin,Np-Nl+1,p),expBoundedDeltaYmax=Basic.expandBoundedX(boundedDeltaYmax,Np-Nl+1,p));
    parameter Real[:,:] Ac = FunctionsStateSpace.ConstraintsMatrix(rcdConstraints,P,p,m,n,Nl,Np,Nu,A,B,C,D)
      "matrix of constraints (Ac*deltaU <= bc)";

  public
    Modelica.Blocks.Interfaces.RealInput y[p]
      annotation (Placement(transformation(extent={{-120,-58},{-80,-18}},
            rotation=0)));

  initial equation
    b = zeros(p);
    y_est = zeros(p);

  equation
    when sample(0, Ts) then
      // measureable disturbances
      if q > 0 then
        if DisturbanceInput == 0 then                                    // input is current measurement only
          disturbance = Basic.repVec(d,q,Np-Nl+1);                             // d hat groe�e q, in jedem Zustand gemessener Wert wird �ber den ganzen Horizont konstant angenommen
        else                                                             // input is entire prospective trajectory
          disturbance = d;                                                     // d hat groe�e q*(Np-Nl+1)
        end if;
      else
        disturbance = zeros(q*(Np-Nl+1));
      end if;

      // prediction bias
      y_est = C*(A*x + B*u);
      // Debug.printVector(y_est,"y_est = ");
      b = y - pre(y_est);
      deltaY = y - pre(y);

      // ...
      deltaU = FunctionsStateSpace.calculateOutput(H,GhT,A,B,C,D,F,E,Ac,r,cat(1,x,unitDelay.y),unitDelay.y,disturbance,Nl,Np,Nu,p,m,n,rcdConstraints,SolverParams);

      // prediction of y for the following discrete time step
      // ...

      // prediction of y for the current discrete time step made in the previous discrete time step
      // ...

    end when;

    annotation (Icon(graphics={Rectangle(
            extent={{-8,-42},{74,-74}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-8,-74},{74,-42}},
            lineColor={0,0,0},
            textString=
                 "A, B, C, D")}),             Diagram(graphics),
      DymolaStoredErrors);
  end MPCstatespace;

  model RTG
    "reference trajectory generatorModelica predictive control library (by the Institute of Automatic Control, RWTH Aachen University)"
  // Please cite the following publication if you are using the library for your own research:
  //   S. Hoelemann and D. Abel,
  //   Modelica Predictive Control -- An MPC Library for Modelica,
  //   at - Automatisierungstechnik, 2009, Vol. 57, pp. 187-194.

    type RTGtype
      extends Integer(min=0, max=2);
      annotation (Evaluate=true, choices(
        choice=0 "constant output",
        choice=1 "keep current input value",
        choice=2 "buffer current input value"));
    end RTGtype;

    parameter Integer p = 1 "number of control systems outputs";
    parameter Integer Nl = 1 "lower prediction horizon";
    parameter Integer Np = 1 "upper prediction horizon";
    parameter RTGtype how = 0
      "define how trajectory is generated from current set points";
    parameter Real howPar = 1 "optional parameter for 'how'";
    parameter Real Ts = 1 "sample time";

    Modelica.Blocks.Interfaces.RealInput w[p]
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput r[p*(Np-Nl+1)]
                                            annotation (Placement(
          transformation(extent={{80,-20},{120,20}}, rotation=0)));

  protected
    Modelica.Blocks.Discrete.UnitDelay unitDelay[(p*(Np - Nl + 1))](y_start=zeros(
           p*(Np - Nl + 1)))
      annotation (Placement(transformation(extent={{60,-40},{40,-20}}, rotation
            =0)));

  equation
    when sample(0, Ts) then
      if how ==0 then //constant output
        r = howPar*ones(p*(Np-Nl+1));
      elseif how == 1 then
        r = Basic.repVec(     w,p,(Np-Nl+1));
      elseif how == 2 then
        r = cat(1, unitDelay[(p+1):end].y, w[:]);
      end if;

    end when;
    connect(unitDelay.u, r) annotation (Line(
        points={{62,-30},{88,-30},{88,0},{100,0}},
        color={0,0,127},
        thickness=1));
    annotation (Diagram(graphics),
                         Icon(graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Sphere,
            fillColor={255,128,0}),
          Text(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.VerticalCylinder,
            textString=
                 "RTG"),
          Text(
            extent={{-100,-80},{100,-100}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString=
                 "MPC Toolbox")}));
  end RTG;

  package Test
    model testMPCstepresponse

    parameter Real S[:,:,:] = {
    {{ 0.068694}},
    {{ 0.228203}},
    {{ 0.428276}},
    {{ 0.638491}},
    {{ 0.841183}},
    {{ 1.026985}},
    {{ 1.191672}},
    {{ 1.334241}},
    {{ 1.455546}},
    {{ 1.557447}},
    {{ 1.642147}},
    {{ 1.711834}},
    {{ 1.768740}},
    {{ 1.814972}},
    {{ 1.852366}},
    {{ 1.882494}},
    {{ 1.906680}},
    {{ 1.926048}},
    {{ 1.941520}},
    {{ 1.953835}},
    {{ 1.963627}},
    {{ 1.971378}},
    {{ 1.977515}},
    {{ 1.982352}},
    {{ 1.986159}},
    {{ 1.989161}},
    {{ 1.991512}},
    {{ 1.993354}},
    {{ 1.994794}},
    {{ 1.995922}},
    {{ 1.996796}}};

      linearMPC.MPCstepresponse linMPCstepresponse1(
        Ts=1,
        R={{0.1}},
        S=S,
        DisturbanceInput=0,
        biasCompensation=1,
        Ymax={1.02},
        deltaUmax={1.5},
        Np=24,
        Nu=24,
        Nm=31,
        constraints=1,
        deltaYmin={-0.01},
        boundedDeltaYmax={1},
        deltaYmax={0.1})                     annotation (Placement(
            transformation(extent={{20,-22},{40,-2}}, rotation=0)));
      Modelica.Blocks.Sources.Step step1(
        offset=0,
        height=1,
        startTime=2)
                  annotation (Placement(transformation(extent={{-100,60},{-80,
                80}}, rotation=0)));
      Modelica.Blocks.Sources.Step step2(
        offset=0,
        height=1,
        startTime=4)
                  annotation (Placement(transformation(extent={{-40,70},{-20,90}},
              rotation=0)));
      Modelica.Blocks.Sources.Step step3(
        offset=0,
        startTime=10,
        height=1) annotation (Placement(transformation(extent={{20,70},{40,90}},
              rotation=0)));
      Modelica.Blocks.Math.Add add1(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{-70,40},{-50,60}}, rotation=0)));
      Modelica.Blocks.Math.Add add2(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{-10,40},{10,60}}, rotation=0)));
      Modelica.Blocks.Math.Add add3(k1=0)
                                   annotation (Placement(transformation(extent=
                {{50,40},{70,60}}, rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder(     T=3, k=2)
        annotation (Placement(transformation(extent={{-40,40},{-20,60}},
              rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder1(T=4)
        annotation (Placement(transformation(extent={{20,40},{40,60}}, rotation
              =0)));
      RTG rTG(       how=1, Np=24)
                            annotation (Placement(transformation(extent={{-40,
                -20},{-20,0}}, rotation=0)));
      Modelica.Blocks.Sources.Step step4(
        offset=0,
        startTime=1,
        height=1) annotation (Placement(transformation(extent={{-80,-20},{-60,0}},
              rotation=0)));
    equation
      connect(step3.y,add3. u1) annotation (Line(points={{41,80},{48,80},{48,56}},
            color={0,0,127}));
      connect(step2.y,add2. u1) annotation (Line(points={{-19,80},{-12,80},{-12,
              56}}, color={0,0,127}));
      connect(step1.y,add1. u1) annotation (Line(points={{-79,70},{-76,70},{-76,
              56},{-72,56}}, color={0,0,127}));
      connect(add1.y, firstOrder.u) annotation (Line(points={{-49,50},{-42,50}},
            color={0,0,127}));
      connect(firstOrder.y, add2.u2) annotation (Line(points={{-19,50},{-16,50},
              {-16,44},{-12,44}}, color={0,0,127}));
      connect(add2.y, firstOrder1.u) annotation (Line(points={{11,50},{18,50}},
            color={0,0,127}));
      connect(firstOrder1.y, add3.u2) annotation (Line(points={{41,50},{44,50},
              {44,44},{48,44}}, color={0,0,127}));
      connect(linMPCstepresponse1.u[1], add1.u2) annotation (Line(points={{40,
              -12},{52,-12},{52,20},{-84,20},{-84,44},{-72,44}}, color={0,0,127}));
      connect(rTG.r, linMPCstepresponse1.r) annotation (Line(points={{-20,-10},
              {-8,-10},{-8,-4},{20,-4}}, color={0,0,127}));
      connect(linMPCstepresponse1.y[1], add3.y) annotation (Line(points={{20,
              -12},{8,-12},{8,-30},{86,-30},{86,50},{71,50}}, color={0,0,127}));
      connect(step4.y, rTG.w[1]) annotation (Line(points={{-59,-10},{-40,-10}},
            color={0,0,127}));
      annotation (Diagram(graphics),
        experiment(StopTime=100),
        experimentSetupOutput);
    end testMPCstepresponse;

    model testMPCstatespace

      parameter Real[:,:] Ad = {{0.8465, 0},
                                {0.108, 0.8825}};
      parameter Real[:,:] Bd = {{0.307},
                                {0.01892}};
      parameter Real[:,:] Cd = {{0, 1}};
      parameter Real[:,:] Dd = {{0}};
      parameter Real[:,:] Ads = {{0},
                                {0.1175}};

      parameter Real Ts = 0.5 "sample time";

      Modelica.Blocks.Sources.Step step6(
        offset=0,
        height=1,
        startTime=2)
                  annotation (Placement(transformation(extent={{-76,30},{-56,50}},
              rotation=0)));
      Modelica.Blocks.Sources.Step step8(
        offset=0,
        startTime=10,
        height=1) annotation (Placement(transformation(extent={{44,38},{64,58}},
              rotation=0)));
      Modelica.Blocks.Math.Add add7(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{-46,8},{-26,28}}, rotation=0)));
      Modelica.Blocks.Math.Add add8(k1=1)
                                   annotation (Placement(transformation(extent=
                {{14,8},{34,28}}, rotation=0)));
      Modelica.Blocks.Math.Add add9(k1=0)
                                   annotation (Placement(transformation(extent=
                {{74,8},{94,28}}, rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder(     T=3, k=2)
        annotation (Placement(transformation(extent={{-16,8},{4,28}}, rotation=
                0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder2(T=4)
        annotation (Placement(transformation(extent={{44,8},{64,28}}, rotation=
                0)));
      RTG rTG1(
        p=1,
        Ts=Ts,
        how=1,
        Np=24)              annotation (Placement(transformation(extent={{-16,
                -52},{4,-32}}, rotation=0)));
      Modelica.Blocks.Sources.Step step9(
        offset=0,
        startTime=1,
        height=1) annotation (Placement(transformation(extent={{-56,-52},{-36,
                -32}}, rotation=0)));
      MPCstatespace mPCstatespace1(
        A=Ad,
        B=Bd,
        C=Cd,
        Ts=Ts,
        biasCompensation=0,
        n=2,
        R={{0.1}},
        p=1,
        Ymin={-0.5},
        deltaUmin={-0.6},
        deltaYmin={-0.01},
        deltaYmax={0.03},
        deltaXmin={-0.05},
        Xmin={-0.1},
        deltaXmax={0.02},
        Xmax={1.05},
        Ads=Ads,
        q=1,
        Np=24,
        Nu=20,
        boundedYmax={1},
        DisturbanceInput=0,
        Ymax={1.03},
        Umax={1},
        Umin={-1},
        boundedUmin={1},
        boundedUmax={1},
        constraints=1)            annotation (Placement(transformation(extent={
                {20,-50},{40,-30}}, rotation=0)));
      Modelica.Blocks.Sources.Step step1(
        offset=0,
        startTime=40,
        height=1) annotation (Placement(transformation(extent={{-22,50},{-2,70}},
              rotation=0)));
    equation

      connect(step8.y,add9. u1) annotation (Line(points={{65,48},{72,48},{72,24}},
            color={0,0,127}));
      connect(step6.y,add7. u1) annotation (Line(points={{-55,40},{-52,40},{-52,
              24},{-48,24}}, color={0,0,127}));
      connect(add7.y,firstOrder. u) annotation (Line(points={{-25,18},{-18,18}},
            color={0,0,127}));
      connect(firstOrder.y,add8. u2) annotation (Line(points={{5,18},{8,18},{8,
              12},{12,12}}, color={0,0,127}));
      connect(add8.y,firstOrder2. u) annotation (Line(points={{35,18},{42,18}},
            color={0,0,127}));
      connect(firstOrder2.y,add9. u2) annotation (Line(points={{65,18},{68,18},
              {68,12},{72,12}}, color={0,0,127}));
      connect(step9.y, rTG1.w[1])
                                 annotation (Line(points={{-35,-42},{-16,-42}},
            color={0,0,127}));
      connect(rTG1.r, mPCstatespace1.r)
                                      annotation (Line(points={{4,-42},{12,-42},
              {12,-32},{20,-32}}, color={0,0,127}));
      connect(firstOrder.y, mPCstatespace1.x[1])
                                                annotation (Line(points={{5,18},
              {12,18},{12,-41},{20,-41}}, color={0,0,127}));
      connect(firstOrder2.y, mPCstatespace1.x[2])
                                                 annotation (Line(points={{65,
              18},{66,18},{66,-16},{12,-16},{12,-39},{20,-39}}, color={0,0,127}));
      connect(mPCstatespace1.u[1], add7.u2)
                                           annotation (Line(points={{40,-40},{
              62,-40},{62,-22},{-62,-22},{-62,12},{-48,12}}, color={0,0,127}));
      connect(add9.y, mPCstatespace1.y[1]) annotation (Line(points={{95,18},{96,
              18},{96,-62},{16,-62},{16,-43.8},{20,-43.8}}, color={0,0,127}));
      connect(step1.y, add8.u1) annotation (Line(points={{-1,60},{6,60},{6,24},
              {12,24}}, color={0,0,127}));
      connect(step1.y, mPCstatespace1.d[1]) annotation (Line(points={{-1,60},{6,
              60},{6,-48},{20,-48}}, color={0,0,127}));
      annotation (Diagram(graphics),
        experiment(StopTime=100),
        experimentSetupOutput);
    end testMPCstatespace;

    model testMPCstatespace2

        parameter Real[:,:] Ad = {{1.902,  -0.9048,        0,        0,        0,    0},
                                  {1,        0,        0,        0,        0,        0},
                                  {0,        0,  0.9048,        0,        0,        0},
                                  {0,        0,        0,   0.8607,        0,        0},
                                  {0,        0,        0,        0,    1.927,  -0.9277},
                                  {0,        0,        0,        0,        1,        0}};
        parameter Real[:,:] Bd = {{0.0625,         0},
                                    {0,              0},
                                    {0.5,            0},
                                    {0,            0.5},
                                    {0,        0.03125},
                                    {0,              0}};
        parameter Real[:,:] Cd = {{0.01935,  0.01871,        0,        -0.9286,        0,        0},
                                    {0,        0,              0.9516,         0,     0.01951,     0.01903}};
        parameter Real[:,:] Dd = {{0,0},
                                    {0,0}};
        parameter Real Ts = 0.5 "sample time";

      Modelica.Blocks.Sources.Step step5(
        offset=0,
        height=1,
        startTime=2)
                  annotation (Placement(transformation(extent={{-116,44},{-96,
                64}}, rotation=0)));
      Modelica.Blocks.Sources.Step step7(
        offset=0,
        startTime=10,
        height=1) annotation (Placement(transformation(extent={{36,66},{56,86}},
              rotation=0)));
      Modelica.Blocks.Math.Add add4(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{-72,38},{-52,58}}, rotation=0)));
      Modelica.Blocks.Math.Add add5(                   k1=+1, k2=-1)
                                   annotation (Placement(transformation(extent=
                {{30,34},{50,54}}, rotation=0)));
      Modelica.Blocks.Math.Add add6(k1=0)
                                   annotation (Placement(transformation(extent=
                {{78,34},{98,54}}, rotation=0)));
      RTG rTG1(      how=1,
        p=2,
        Ts=Ts,
        Np=18)              annotation (Placement(transformation(extent={{-34,
                -92},{-14,-72}}, rotation=0)));
      Modelica.Blocks.Sources.Step step8[2](
        offset=0,
        startTime=1,
        height=0.5)
                  annotation (Placement(transformation(extent={{-78,-92},{-58,
                -72}}, rotation=0)));
      MPCstatespace mPCstatespace1(
        A=Ad,
        B=Bd,
        C=Cd,
        Ts=Ts,
        biasCompensation=0,
        Ymin={-0.5},
        Umin={-0.5},
        Umax={0.85},
        deltaUmin={-0.6},
        deltaUmax={0.8},
        Ymax={0.5},
        deltaYmin={-0.01},
        deltaYmax={0.03},
        deltaXmin={-0.05},
        Xmin={-0.1},
        Xmax={0.505},
        p=2,
        m=2,
        n=6,
        R={{0.1,0},{0,0.1}},
        Np=18,
        Nu=12,
        constraints=1)            annotation (Placement(transformation(extent={
                {28,-88},{48,-68}}, rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder3(     T=10/3, k=1)
        annotation (Placement(transformation(extent={{-38,-18},{-18,2}},
              rotation=0)));
      Modelica.Blocks.Math.Add add7(k1=+1)
                                   annotation (Placement(transformation(extent=
                {{36,-32},{56,-12}}, rotation=0)));
      Modelica.Blocks.Math.Add add8(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{-74,-32},{-54,-12}}, rotation=0)));
      Modelica.Blocks.Math.Add add9(      k1=0)
                                   annotation (Placement(transformation(extent=
                {{80,-34},{100,-14}}, rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder2(k=1, T=5)
        annotation (Placement(transformation(extent={{-38,12},{-18,32}},
              rotation=0)));
      Modelica.Blocks.Sources.Step step9(
        offset=0,
        height=1,
        startTime=2)
                  annotation (Placement(transformation(extent={{-116,-26},{-96,
                -6}}, rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1, T=10)
        annotation (Placement(transformation(extent={{-38,42},{-18,62}},
              rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder4(k=1, T=10)
        annotation (Placement(transformation(extent={{-6,42},{14,62}}, rotation
              =0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder5(k=1, T=10)
        annotation (Placement(transformation(extent={{-38,-46},{-18,-26}},
              rotation=0)));
      Modelica.Blocks.Continuous.FirstOrder firstOrder6(k=1, T=20)
        annotation (Placement(transformation(extent={{-6,-44},{14,-24}},
              rotation=0)));
    equation
      connect(rTG1.r, mPCstatespace1.r)
                                      annotation (Line(points={{-14,-82},{-6,
              -82},{-6,-70},{28,-70}}, color={0,0,127}));
      connect(add8.y, firstOrder3.u) annotation (Line(points={{-53,-22},{-48,
              -22},{-48,-8},{-40,-8}}, color={0,0,127}));
      connect(firstOrder2.y, add7.u1) annotation (Line(points={{-17,22},{16,22},
              {16,-16},{34,-16}}, color={0,0,127}));
      connect(step9.y, add8.u1) annotation (Line(points={{-95,-16},{-76,-16}},
            color={0,0,127}));
      connect(add7.y, add9.u2) annotation (Line(points={{57,-22},{66,-22},{66,
              -30},{78,-30}}, color={0,0,127}));
      connect(step7.y, add9.u1) annotation (Line(points={{57,76},{70,76},{70,
              -18},{78,-18}}, color={0,0,127}));
      connect(mPCstatespace1.u[1], add4.u2) annotation (Line(points={{48,-79},{
              56,-79},{56,-54},{-90,-54},{-90,42},{-74,42}}, color={0,0,127}));
      connect(add5.y, add6.u2) annotation (Line(points={{51,44},{58,44},{58,38},
              {76,38}}, color={0,0,127}));
      connect(add4.y, firstOrder2.u) annotation (Line(points={{-51,48},{-46,48},
              {-46,22},{-40,22}}, color={0,0,127}));
      connect(firstOrder3.y, add5.u2) annotation (Line(points={{-17,-8},{24,-8},
              {24,38},{28,38}}, color={0,0,127}));
      connect(step5.y, add4.u1) annotation (Line(points={{-95,54},{-74,54}},
            color={0,0,127}));
      connect(step7.y, add6.u1) annotation (Line(points={{57,76},{70,76},{70,50},
              {76,50}}, color={0,0,127}));
      connect(mPCstatespace1.u[2], add8.u2) annotation (Line(points={{48,-77},{
              50,-77},{50,-62},{-84,-62},{-84,-28},{-76,-28}}, color={0,0,127}));
      connect(add8.y, firstOrder5.u) annotation (Line(points={{-53,-22},{-46,
              -22},{-46,-36},{-40,-36}}, color={0,0,127}));
      connect(firstOrder5.y, firstOrder6.u) annotation (Line(points={{-17,-36},
              {-12,-36},{-12,-34},{-8,-34}}, color={0,0,127}));
      connect(firstOrder6.y, add7.u2) annotation (Line(points={{15,-34},{22,-34},
              {22,-28},{34,-28}}, color={0,0,127}));
      connect(add4.y, firstOrder1.u) annotation (Line(points={{-51,48},{-44,48},
              {-44,52},{-40,52}}, color={0,0,127}));
      connect(firstOrder1.y, firstOrder4.u) annotation (Line(points={{-17,52},{
              -8,52}}, color={0,0,127}));
      connect(firstOrder1.y, mPCstatespace1.x[1]) annotation (Line(points={{-17,
              52},{-14,52},{-14,-66},{-2,-66},{-2,-79.6667},{28,-79.6667}},
            color={0,0,127}));
      connect(firstOrder4.y, mPCstatespace1.x[2]) annotation (Line(points={{15,
              52},{18,52},{18,-60},{4,-60},{4,-79},{28,-79}}, color={0,0,127}));
      connect(firstOrder4.y, add5.u1) annotation (Line(points={{15,52},{24,52},
              {24,50},{28,50}}, color={0,0,127}));
      connect(add6.y, mPCstatespace1.y[1]) annotation (Line(points={{99,44},{
              108,44},{108,-98},{0,-98},{0,-82.8},{28,-82.8}}, color={0,0,127}));
      connect(add9.y, mPCstatespace1.y[2]) annotation (Line(points={{101,-24},{
              104,-24},{104,-96},{4,-96},{4,-80.8},{28,-80.8}}, color={0,0,127}));
      connect(step8.y, rTG1.w) annotation (Line(points={{-57,-82},{-34,-82}},
            color={0,0,127}));
      connect(firstOrder5.y, mPCstatespace1.x[3]) annotation (Line(points={{-17,
              -36},{-16,-36},{-16,-68},{-4,-68},{-4,-78.3333},{28,-78.3333}},
            color={0,0,127}));
      connect(firstOrder6.y, mPCstatespace1.x[4]) annotation (Line(points={{15,
              -34},{20,-34},{20,-64},{10,-64},{10,-77.6667},{28,-77.6667}},
            color={0,0,127}));
      connect(firstOrder2.y, mPCstatespace1.x[5]) annotation (Line(points={{-17,
              22},{-10,22},{-10,-77},{28,-77}}, color={0,0,127}));
      connect(firstOrder3.y, mPCstatespace1.x[6]) annotation (Line(points={{-17,
              -8},{-8,-8},{-8,-10},{4,-10},{4,-76.3333},{28,-76.3333}}, color={
              0,0,127}));
      annotation (Diagram(graphics={
            Text(
              extent={{104,48},{112,42}},
              lineColor={0,0,255},
              textString=
                   "y1"),
            Text(
              extent={{104,-20},{112,-26}},
              lineColor={0,0,255},
              textString=
                   "y2"),
            Text(
              extent={{-84,42},{-76,36}},
              lineColor={0,0,255},
              textString=
                   "u1"),
            Text(
              extent={{-82,-32},{-74,-38}},
              lineColor={0,0,255},
              textString=
                   "u2")}),
        experiment(StopTime=100),
        experimentSetupOutput);
    end testMPCstatespace2;

    model testMPCstatespace2_2

        parameter Real Ad[6,6]=
      {{    1.72897862747521,   -0.747017500310433,                    0,                    0,                    0,                    0},
       {                   1,                    0,                    0,                    0,                    0,                    0},
       {                   0,                    0,    0.818730753077982,                    0,                    0,                    0},
       {                   0,                    0,                    0,    0.740818220681718,                    0,                    0},
       {                   0,                    0,                    0,                    0,     1.85606684253667,   -0.860707976425058},
       {                   0,                    0,                    0,                    0,                    1,                    0}};
        parameter Real Bd[6,2]=
      {{               0.125,                    0},
       {                   0,                    0},
       {                   1,                    0},
       {                   0,                    1},
       {                   0,               0.0625},
       {                   0,                    0}};
        parameter Real Cd[2,6]=
      {{  0.0756605146676849,   0.0686504680140996,                    0,   -0.863939264394274,                    0,                    0},
       {                   0,                    0,    0.906346234610091,                    0,   0.0380571045525049,   0.0362010376616428}};
        parameter Real Dd[2,2]=
      {{                   0,                    0},
       {                   0,                    0}};
        parameter Real Ts = 1 "sample time";
        Real deltaY[2];

      RTG rTG1(      how=1,
        p=2,
        Ts=Ts,
        Np=18)              annotation (Placement(transformation(extent={{-32,
                -78},{-12,-58}}, rotation=0)));
      Modelica.Blocks.Sources.Step step8[2](
        offset=0,
        height=1,
        startTime=0)
                  annotation (Placement(transformation(extent={{-78,-78},{-58,
                -58}}, rotation=0)));
      MPCstatespace mPCstatespace1(
        A=Ad,
        B=Bd,
        C=Cd,
        Ts=Ts,
        p=2,
        m=2,
        n=6,
        deltaUmax={0.2},
        deltaXmin={-0.0035},
        deltaYmin={-0.8},
        Umin={-0.4},
        Umax={0.2},
        deltaUmin={-0.1},
        Np=18,
        Nu=13,
        deltaXmax={0.04},
        biasCompensation=0,
        Ymin={0.5},
        Ymax={0.9},
        R={{0.1,0},{0,0.1}},
        Xmax={0.7},
        deltaYmax={0.9},
        Xmin={-0.7},
        boundedXmin={4},
        constraints=0)            annotation (Placement(transformation(extent={
                {32,-78},{52,-58}}, rotation=0)));
      Modelica.Blocks.Continuous.StateSpace stateSpace1(
        D={{0,0},{0,0}},
        A={{-0.291667,-0.166667,0,0,0,0},{0.125,0,0,0,0,0},{0,0,-0.2,0,0,0},{0,
            0,0,-0.3,0,0},{0,0,0,0,-0.15,-0.08},{0,0,0,0,0.0625,0}},
        B={{0.5,0},{0,0},{1,0},{0,1},{0,0.25},{0,0}},
        C={{0,0.333333,0,-1,0,0},{0,0,1,0,0,0.32}})
                         annotation (Placement(transformation(extent={{-20,70},
                {0,90}}, rotation=0)));
      Modelica.Blocks.Discrete.UnitDelay unitDelay2[2](samplePeriod=Ts)
        annotation (Placement(transformation(extent={{66,68},{86,88}}, rotation
              =0)));
      Modelica.Blocks.Discrete.UnitDelay unitDelay3[2](samplePeriod=Ts)
        annotation (Placement(transformation(extent={{32,68},{52,88}}, rotation
              =0)));
      Modelica.Blocks.Discrete.StateSpace stateSpace(
        samplePeriod=Ts,
        D=zeros(6, 2),
        A=Ad,
        B=Bd,
        C=identity(6)) annotation (Placement(transformation(extent={{-20,8},{0,
                28}}, rotation=0)));
      Modelica.Blocks.Discrete.UnitDelay unitDelay4[6](samplePeriod=Ts)
        annotation (Placement(transformation(extent={{34,8},{54,28}}, rotation=
                0)));
    equation
      connect(rTG1.r, mPCstatespace1.r)
                                      annotation (Line(points={{-12,-68},{-6,
              -68},{-6,-60},{32,-60}}, color={0,0,127}));
      connect(step8.y, rTG1.w) annotation (Line(points={{-57,-68},{-32,-68}},
            color={0,0,127}));
      connect(stateSpace1.y, mPCstatespace1.y) annotation (Line(points={{1,80},
              {24,80},{24,-71.8},{32,-71.8}}, color={0,0,127}));
      deltaY = unitDelay3.u - unitDelay2.y;

      connect(stateSpace1.y, unitDelay3.u) annotation (Line(points={{1,80},{16,
              80},{16,78},{30,78}}, color={0,0,127}));
      connect(unitDelay3.y, unitDelay2.u)
        annotation (Line(points={{53,78},{64,78}}, color={0,0,127}));
      connect(mPCstatespace1.u, stateSpace1.u) annotation (Line(points={{52,-68},
              {92,-68},{92,-10},{-38,-10},{-38,80},{-22,80}}, color={0,0,127}));
      connect(mPCstatespace1.u, stateSpace.u) annotation (Line(points={{52,-68},
              {92,-68},{92,-10},{-38,-10},{-38,16},{-22,16},{-22,18}}, color={0,
              0,127}));
      connect(stateSpace.y, unitDelay4.u) annotation (Line(points={{1,18},{32,
              18}}, color={0,0,127}));
      connect(unitDelay4.y, mPCstatespace1.x) annotation (Line(points={{55,18},
              {62,18},{62,-30},{16,-30},{16,-68},{32,-68}}, color={0,0,127}));
      annotation (Diagram(graphics),
                           experiment(StopTime=100),
        experimentSetupOutput);
    end testMPCstatespace2_2;
  end Test;
  annotation (uses(Modelica(version="3.2")), version="1");
end linearMPC;
