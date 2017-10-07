--Striking Page-Turner
function c515181112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c515181112.target)
	e1:SetOperation(c515181112.activate)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c515181112.postg)
	e2:SetOperation(c515181112.posop)
	c:RegisterEffect(e2)
end
function c515181112.filter(c)
	return c:IsFacedown() and c:GetSequence()<5 and c:IsControler(tp)
end
function c515181112.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c515181112.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or not tc:IsFacedown() then return end
    if Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE))~=0
        and tc:GetSequence()<5 and tc:GetColumnGroup(1,1):FilterCount(c515181112.filter,nil,tp)
        and Duel.SelectYesNo(tp,aux.Stringid(3648368,0)) then
        Duel.BreakEffect()
        local dg=tc:GetColumnGroup(1,1):Filter(c515181112.filter,nil,tp)
        ::start::
        if dg:GetCount()==1 then
            Duel.ChangePosition(dg:GetFirst(),Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE))
        else
            local dc=dg:Select(tp,1,1,nil):GetFirst()
            dg:RemoveCard(dc)
            Duel.ChangePosition(dc,Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE))
            if  dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(3648368,0)) then
                goto start
            end
       end
    end
end
function c515181112.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c515181112.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c515181112.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c515181112.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c515181112.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c515181112.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end